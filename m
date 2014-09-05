Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaIERdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:33:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54512 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaIERd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:33:28 -0400
Date: Fri, 5 Sep 2014 10:32:56 -0700
From: Kees Cook <keescook@chromium.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, mingo@redhat.com,
        whissi@whissi.de, dyoung@redhat.com, tglx@linutronix.de,
        vgoyal@redhat.com, keescook@chromium.org, chaowang@redhat.com
Subject: Re: [PATCH 3/4] kaslr setup_data handling
Message-ID: <20140905173256.GV5598@outflux.net>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-4-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409926097-2101-4-git-send-email-bhe@redhat.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:08:16PM +0800, Baoquan He wrote:
> From: Dave Young <dyoung@redhat.com>
> 
> X86 will pass setup_data region while necessary, these regions could be
> overwitten by kernel due to kaslr.
> 
> Thus iterate and add setup regions to mem_avoid[] in this patch.
> Up to now there isn't a official data to state the maximal entries
> setup data could use. So just set max mem avoid entries 32, hopefully
> it will be enough. This can be increased later when people report
> they are using more setup data entries.

Ew, yes, this is bad. I hadn't seen setup_data while designing the
mem_avoid stuff. I don't like the fixed 32 entry size here, so let me
consider some options. I think the mem_avoid logic can just walk the
setup_data list itself, since that's what it's for. :)

Does only kexec use this? I assume other boot loaders must be using this
too. Is there an easy test case for validating this is fixed?

> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  arch/x86/boot/compressed/aslr.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> index 975b07b..7e92fc8 100644
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -110,8 +110,9 @@ struct mem_vector {
>  	unsigned long size;
>  };
>  
> -#define MEM_AVOID_MAX 5
> +#define MEM_AVOID_MAX 32
>  static struct mem_vector mem_avoid[MEM_AVOID_MAX];
> +static int mem_avoid_nr;
>  
>  static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
>  {
> @@ -135,6 +136,27 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
>  	return true;
>  }
>  
> +static void mem_avoid_setup_data(void)
> +{
> +	struct setup_data *data;
> +	u64 pa_data;
> +
> +	pa_data = real_mode->hdr.setup_data;
> +	while (pa_data) {
> +		if (mem_avoid_nr >= MEM_AVOID_MAX) {
> +			debug_putstr("KASLR: too many setup_data ranges.\n");
> +			return;
> +		}
> +		data = (struct setup_data *)pa_data;
> +		if (pa_data < CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
> +			mem_avoid[mem_avoid_nr].start = pa_data;
> +			mem_avoid[mem_avoid_nr].size = sizeof(*data) + data->len;
> +			mem_avoid_nr++;
> +		}
> +		pa_data = data->next;
> +	}
> +}
> +
>  static void mem_avoid_init(unsigned long input, unsigned long input_size,
>  			   unsigned long output, unsigned long output_size)
>  {
> @@ -177,6 +199,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>  	/* Avoid stack memory. */
>  	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
>  	mem_avoid[4].size = BOOT_STACK_SIZE;
> +	mem_avoid_nr = 5;
> +
> +	mem_avoid_setup_data();
>  }
>  
>  /* Does this memory vector overlap a known avoided area? */
> @@ -184,7 +209,7 @@ static bool mem_avoid_overlap(struct mem_vector *img)
>  {
>  	int i;
>  
> -	for (i = 0; i < MEM_AVOID_MAX; i++) {
> +	for (i = 0; i < mem_avoid_nr; i++) {
>  		if (mem_overlaps(img, &mem_avoid[i]))
>  			return true;
>  	}
> -- 
> 1.8.5.3

Here's an alternative... can you test it?

---
Subject: x86, kaslr: avoid setup_data when choosing kernel location

The KASLR location-choosing logic needs to avoid the setup_data list
areas as well.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index fc6091abedb7..7c75c22d9bc3 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -112,6 +112,7 @@ struct mem_vector {
 
 #define MEM_AVOID_MAX 5
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
+static struct setup_data *setup_data_avoid;
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
 {
@@ -177,17 +178,30 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	/* Avoid stack memory. */
 	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
 	mem_avoid[4].size = BOOT_STACK_SIZE;
+
+	/* Locate the setup_data list, if it exists. */
+	setup_data_avoid = (struct setup_data *)real_mode->hdr.setup_data;
 }
 
 /* Does this memory vector overlap a known avoided area? */
 static bool mem_avoid_overlap(struct mem_vector *img)
 {
 	int i;
+	struct setup_data *ptr;
 
 	for (i = 0; i < MEM_AVOID_MAX; i++) {
 		if (mem_overlaps(img, &mem_avoid[i]))
 			return true;
 	}
+	for (ptr = setup_data_avoid; ptr; ptr = ptr->next) {
+		struct mem_vector avoid;
+
+		avoid.start = (u64)ptr;
+		avoid.size = sizeof(*ptr) + ptr->len;
+
+		if (mem_overlaps(img, &avoid))
+			return true;
+	}
 
 	return false;
 }

-- 
Kees Cook
Chrome OS Security
