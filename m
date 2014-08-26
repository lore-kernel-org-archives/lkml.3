Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbaHZLxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:53:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbaHZLxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:53:51 -0400
Date: Tue, 26 Aug 2014 19:53:46 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3] not adding modules range to kcore if it's equal to
 vmcore range
Message-ID: <20140826115346.GA1725@dhcp-16-116.nay.redhat.com>
References: <1409053105-3631-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409053105-3631-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 at 07:38pm, Baoquan He wrote:
> On some ARCHs modules range is eauql to vmalloc range. E.g on i686
> "#define MODULES_VADDR   VMALLOC_START"
> "#define MODULES_END     VMALLOC_END"
> This will cause 2 duplicate program segments in /proc/kcore, and no
> any flag to indicate both of them are different. This is confusing.
> 
> And usually people who need check the elf header or read the content
> of kcore will check memory ranges. Two program segments which are the
> same completely can't give any help on this.
> 
> So in this patch a judgment added to check if modules range is equal
> to or included in vmalloc range completely. If yes, just skip adding
> the modules range. If and only if modules range is not completely
> included in vmalloc range just add it since the part out of vmalloc
> range need be accessible.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  fs/proc/kcore.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index 6df8d07..a4b7ff1 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -610,8 +610,11 @@ static void __init proc_kcore_text_init(void)
>  struct kcore_list kcore_modules;
>  static void __init add_modules_range(void)
>  {
> -	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> +	if ( (MODULES_VADDR != VMALLOC_START) &&
> +		(MODULES_END <= VMALLOC_END) ) {

Oh, the check should be like below expression which can denote that
modules range is equal to or included in vmalloc range.

if ((MODULES_VADDR >= VMALLOC_START) && (MODULES_END <= VMALLOC_END) ) {

Nack this patch, will post a new one.

> +		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
>  			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> +	}
>  }
>  #else
>  static void __init add_modules_range(void)
> -- 
> 1.9.0
> 
