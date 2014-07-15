Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbaGOWQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043AbaGOWQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:16:03 -0400
Date: Tue, 15 Jul 2014 15:16:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, qiuxishi@huawei.com,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH v2] not adding modules range to kcore if it's equal to
 vmcore range
Message-Id: <20140715151600.b561ab770b5b0f9a2200b49f@linux-foundation.org>
In-Reply-To: <20140713010546.GA2832@dhcp-17-102.nay.redhat.com>
References: <1405212144-2725-1-git-send-email-bhe@redhat.com>
	<20140713010546.GA2832@dhcp-17-102.nay.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2014 09:05:46 +0800 Baoquan He <bhe@redhat.com> wrote:

> On some ARCHs modules range is eauql to vmalloc range. E.g on i686
> "#define MODULES_VADDR   VMALLOC_START"
> "#define MODULES_END     VMALLOC_END"
> This will cause 2 duplicate program segments in /proc/kcore, makes
> user confused. In this patch a judgment added to check if modules
> range is equal to vmalloc range. If yes, just skip adding the modules
> range.
> 
> ...
>
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -610,8 +610,10 @@ static void __init proc_kcore_text_init(void)
>  struct kcore_list kcore_modules;
>  static void __init add_modules_range(void)
>  {
> -	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> -			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> +	if (MODULES_VADDR != VMALLOC_START) {
> +		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> +				MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> +	}
>  }
>  #else
>  static void __init add_modules_range(void)

But if some application or script is using the modules range, won't
this patch cause breakage on some architectures?

