Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaAFK1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:27:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaAFK1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:27:11 -0500
Date: Mon, 6 Jan 2014 11:27:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: riel@redhat.com, walken@google.com, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, wangnan0@huawei.com
Subject: Re: [PATCH] mm: add ulimit API for user
Message-ID: <20140106102707.GA23730@dhcp22.suse.cz>
References: <52C28AAA.5060707@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C28AAA.5060707@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 31-12-13 17:13:14, Xishi Qiu wrote:
> Add ulimit API for users. When memory is not enough, 
> user's app will receive a signal, and it can do something
> in the handler.
> 
> e.g.
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> void handler(int sig)
> {
> char *b = malloc(1000000000);
> memset(b, '\0', 1000000000);
> printf("catch the signal by wwy\n");
> exit(1);
> }
> int main ( int argc, char *argv[] )
> {
> struct rlimit r1 = { 3600000000, 3600000000};
> setrlimit(RLIMIT_AS, &r1);
> signal(47, &handler);
> char * a = malloc(3600000000);
> int fd=open("/home/wayne/qemu.tar.bz2", O_RDONLY);
> char abc[2000000] = {'\0'};
> mmap(NULL, 10000000, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd , 0);
> sleep(100);
> free(a);
> while(1){
> }
> }
> 
> RTOS-x86_64 /tmp # ./a.out
> catch the signal by wwy

How does this demonstrate the newly added knob?
 
[...]
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4ff7f52..a10155f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2402,6 +2402,11 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>   * Return true if the calling process may expand its vm space by the passed
>   * number of pages
>   */
> +
> +#ifdef CONFIG_ULIMIT_VM_SIG
> +unsigned long vm_expand_signal_enable = 0;
> +EXPORT_SYMBOL(vm_expand_signal_enable);
> +#endif
> +
>  int may_expand_vm(struct mm_struct *mm, unsigned long npages)
>  {
>  	unsigned long cur = mm->total_vm;	/* pages */
> @@ -2410,7 +2415,9 @@ int may_expand_vm(struct mm_struct *mm, unsigned long npages)
>  	lim = rlimit(RLIMIT_AS) >> PAGE_SHIFT;
>  
>  	if (cur + npages > lim){
> -		send_sig(SIGRTMIN+15, current, 1);

What kind of tree is this based on? Neither Linus' nor Andrew's tree
sends the signal. And I would be really surprised if such a change would
be accepted at all because may_expand_vm is not supposed to send a
signal. Only automatic stack expansion is supposed to send SEGV other
callers should simply return ENOMEM

> +#ifdef	CONFIG_ULIMIT_VM_SIG
> +		if (vm_expand_signal_enable){
> +			send_sig(SIGRTMIN+15, current, 1);
> +		}
> +#endif
>  		return 0;
>  	}
>  	return 1;
-- 
Michal Hocko
SUSE Labs
