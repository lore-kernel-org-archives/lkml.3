Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3JLUc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:32:56 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54214 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3JLUcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:32:54 -0400
Date: Sat, 12 Oct 2013 23:32:50 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: mmap for /proc/vmcore broken since 3.12-rc1
Message-ID: <20131012203250.GA3458@p183.telecom.by>
References: <20131002140356.63706540@holzheu>
 <524D0ADF.2010507@jp.fujitsu.com>
 <52521FA5.3040101@jp.fujitsu.com>
 <CACVxJT8S7kA92=80DWVmVJJvbnaQ6WkyvsiFq4wP37WHV=tfuA@mail.gmail.com>
 <52552C9F.2030404@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52552C9F.2030404@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 07:14:55PM +0900, HATAYAMA Daisuke wrote:
> Hello,
> 
> (2013/10/08 21:49), Alexey Dobriyan wrote:
> > On Mon, Oct 7, 2013 at 5:42 AM, HATAYAMA Daisuke
> > <d.hatayama@jp.fujitsu.com> wrote:
> >
> >> +static unsigned long
> >> +get_unmapped_area_vmcore(struct file *filp, unsigned long addr,
> >> +                        unsigned long len, unsigned long pgoff,
> >> +                        unsigned long flags)
> >> +{
> >> +#ifdef CONFIG_MMU
> >> +       return current->mm->get_unmapped_area(filp, addr, len, pgoff,
> >> flags);
> >> +#else
> >> +       return -EIO;
> >> +#endif
> >> +}
> >> +
> >>   static const struct file_operations proc_vmcore_operations = {
> >>          .read           = read_vmcore,
> >>          .llseek         = default_llseek,
> >>          .mmap           = mmap_vmcore,
> >> +       .get_unmapped_area = get_unmapped_area_vmcore,
> >
> > I think current->mm->get_unmapped_area should be used by core proc code.
> 
> What do you actually suggest here? You mean moving this code in proc code?
> I don't think you suggest so.

Please, try this patch, I don't have kexec setup handy.

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -291,7 +291,11 @@ static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long
 	int rv = -EIO;
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	if (use_pde(pde)) {
-		get_unmapped_area = pde->proc_fops->get_unmapped_area;
+		get_unmapped_area = current->mm->get_unmapped_area;
+#ifdef CONFIG_MMU
+		if (pde->proc_fops->get_unmapped_area)
+			get_unmapped_area = pde->proc_fops->get_unmapped_area;
+#endif
 		if (get_unmapped_area)
 			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
 		unuse_pde(pde);
