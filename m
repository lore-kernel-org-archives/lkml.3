Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161337Ab3DECed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:34:33 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33844 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161117Ab3DECea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:34:30 -0400
X-Greylist: delayed 1099 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Apr 2013 22:34:30 EDT
Message-ID: <515E3833.7070505@hitachi.com>
Date: Fri, 05 Apr 2013 11:34:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        radovan.lekanovic@sonymobile.com, bjorn.davidsson@sonymobile.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v2 2/4] kprobes: split blacklist into common and arch
References: <1365079889-21525-1-git-send-email-oskar.andero@sonymobile.com> <1365079889-21525-3-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1365079889-21525-3-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/04 21:51), Oskar Andero wrote:
> Some blackpoints are only valid for specific architectures. To let each
> architecture specify its own blackpoints the list has been split in two
> lists: common and arch. The common list is kept in kernel/kprobes.c and
> the arch list is kept in the arch/ directory.
> 

Here I missed one racing issue.

> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 0a270e5..7654278 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
[...]
>  
>  /* it can take some time ( > 100ms ) to initialise the
>   * blacklist so we delay this until we actually need it
>   */
>  static void init_kprobe_blacklist(void)
>  {
> -	int i;
> -	unsigned long offset = 0, size = 0;
> -	char *modname, namebuf[128];
> -	const char *symbol_name;
> -	void *addr;
> -	struct kprobe_blackpoint *kb;
> +	int i, j = 0;
>  
>  	mutex_lock(&kprobe_mutex);
> -	if (kprobe_blacklist_initialized)
> +	if (kprobe_blacklist)
>  		goto out;
>  
> +	kprobe_blacklist_size = common_kprobes_blacksyms_size +
> +				arch_kprobes_blacksyms_size;
> +	kprobe_blacklist = kzalloc(sizeof(*kprobe_blacklist) *
> +				   kprobe_blacklist_size, GFP_KERNEL);

If you'd like to use kprobe_blacklist itself as an initialized flag,
you must prepare the "blacklist" local pointer to allocate and
initialize entries.

> @@ -151,7 +175,6 @@ static void init_kprobe_blacklist(void)
>  				       kretprobe_blacklist[i].name);
>  		}
>  	}
> -	kprobe_blacklist_initialized = 1;

And after initialized, assign blacklist to kprobe_blacklist.

Without that, other thread may refer the uninitialized (but allocated)
black list.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


