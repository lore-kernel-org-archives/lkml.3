Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaDWFl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:41:27 -0400
Received: from ozlabs.org ([103.22.144.67]:40890 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaDWFlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:41:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>,
        "ynvich\@gmail.com" <ynvich@gmail.com>,
        "Lucas De Marchi" <lucas.de.marchi@gmail.com>
Subject: Re: [PATCH v2] fix printk output
In-Reply-To: <1386660574.7152.203.camel@host5.omatika.ru>
References: <20131127220746.GA11255@order.stressinduktion.org> <1385826152-17531-1-git-send-email-ynvich@gmail.com> <87a9g9s27z.fsf@rustcorp.com.au> <1386660574.7152.203.camel@host5.omatika.ru>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Apr 2014 14:44:58 +0930
Message-ID: <87zjjcfwz1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Ianovich <ynvich@gmail.com> writes:
> On Tue, 2013-12-10 at 15:59 +1030, Rusty Russell wrote:
>> BTW, did you actually hit this?
>
> # modprobe usb_storage
> [  600.807274] usbcore: registered new interface driver usb-storage
> # modprobe -r usb_storage
> [  604.216318] waiting module removal not supported: please upgrade[
> 604.222164] usbcore: deregistering interface driver usb-storage
> # modprobe -V
> kmod version 9
>
> I am using the latest kmod package from emdebian unstable-grip.

Sorry, was off on leave.

Hmm, Lucas intimated that kmod version 11 started passing this flag
correctly.

In fact, kmod's modprobe *never* used the O_NONBLOCK
(ie. KMOD_REMOVE_NOWAIT) flag, until it was finally enforced in

commit 7ab8804448377fb6b8854f2dd288608db01bb43b
Author: Lucas De Marchi <lucas.demarchi@intel.com>
Date:   Fri Sep 20 01:30:07 2013 -0500

See: tools/modprobe.c at that commit:

        static int rmmod_do_remove_module(struct kmod_module *mod)
        {
        	const char *modname = kmod_module_get_name(mod);
        	struct kmod_list *deps, *itr;
        	int flags = 0, err;
...
        	if (force)
        		flags |= KMOD_REMOVE_FORCE;

        	err = kmod_module_remove_module(mod, flags);

Perhaps we need to just get rid of the kernel message, since we're
getting far too many false reports :(

Cheers,
Rusty.


