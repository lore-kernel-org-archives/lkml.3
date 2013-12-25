Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3LYDJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 22:09:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab3LYDJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 22:09:54 -0500
Date: Wed, 25 Dec 2013 11:09:01 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "bp@alien8.de" <bp@alien8.de>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Message-ID: <20131225030901.GA6333@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <20131221173515.GE29501@console-pimps.org>
 <1387747621.1848.2.camel@misato.fc.hp.com>
 <20131223073641.GA28919@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223073641.GA28919@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/13 at 07:36am, Matt Fleming wrote:
> On Sun, 22 Dec, at 02:27:01PM, Toshi Kani wrote:
> > 
> > The kexec branch is missing the following change, which is required for
> > fast reboot with multi-cpus.
> > 
> >    commit 279f1df915c3a6ed3075d98a849705bf53851f99
> >    Author: Vivek Goyal <vgoyal@redhat.com>
> >    Date:   Tue Nov 26 10:25:28 2013 +0800
> > 
> >        kexec: migrate to reboot cpu
> > 
> > With this change added, I confirmed that the branch kernel works fine.
>  
> I can't find that commit in Linus' tree. Where is it from?

Previously it was in Andrew's mm tree, currently it's below commit in linus tree:

commit c97102ba96324da330078ad8619ba4dfe840dbe3
Author: Vivek Goyal <vgoyal@redhat.com>
Date:   Wed Dec 18 17:08:31 2013 -0800

    kexec: migrate to reboot cpu
    
    Commit 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic
    kernel") moved reboot= handling to generic code.  In the process it also
    removed the code in native_machine_shutdown() which are moving reboot
    process to reboot_cpu/cpu0.
    
    I guess that thought must have been that all reboot paths are calling
    migrate_to_reboot_cpu(), so we don't need this special handling.  But
    kexec reboot path (kernel_kexec()) is not calling
    migrate_to_reboot_cpu() so above change broke kexec.  Now reboot can
    happen on non-boot cpu and when INIT is sent in second kerneo to bring
    up BP, it brings down the machine.
    
    So start calling migrate_to_reboot_cpu() in kexec reboot path to avoid
    this problem.
    
    Bisected by WANG Chao.
    
    Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
    Reported-by: Dave Young <dyoung@redhat.com>
    Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
    Tested-by: Baoquan He <bhe@redhat.com>
    Tested-by: WANG Chao <chaowang@redhat.com>
    Acked-by: H. Peter Anvin <hpa@linux.intel.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
