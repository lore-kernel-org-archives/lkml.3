Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaFXRcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:32:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbaFXRcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:32:15 -0400
Date: Tue, 24 Jun 2014 13:31:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        gong.chen@linux.intel.com
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140624173125.GA18045@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
 <20140615163515.GA17016@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140615163515.GA17016@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 06:35:15PM +0200, Borislav Petkov wrote:

[..]
> > +int kexec_setup_initrd(struct boot_params *params,
> > +		unsigned long initrd_load_addr, unsigned long initrd_len)
> > +{
> > +	params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
> > +	params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;
> 
> We have more readable GENMASK* macros for contiguous masks. This one
> will then look like:
> 
> 	params->hdr.ramdisk_image = initrd_load_addr & GENMASK(31, 0);
> 	params->hdr.ramdisk_size = initrd_len & GENMASK(31, 0);
> 
> and this way we know exactly about which bits are we talking about. :)

[ CC gong.chen@linux.intel.com ]

GENMASK(31,0) outputs compilation warning.

arch/x86/kernel/machine_kexec.c: In function ‘kexec_setup_initrd’:
arch/x86/kernel/machine_kexec.c:30:2: warning: left shift count >= width
of type [enabled by default]
  params->hdr.ramdisk_image = initrd_load_addr & GENMASK(31, 0);
  ^
arch/x86/kernel/machine_kexec.c:31:2: warning: left shift count >= width
of type [enabled by default]
  params->hdr.ramdisk_size = initrd_len & GENMASK(31, 0);
  ^
arch/x86/kernel/machine_kexec.c: In function ‘kexec_setup_cmdline’:
arch/x86/kernel/machine_kexec.c:52:2: warning: left shift count >= width
of type [enabled by default]
  cmdline_low_32 = cmdline_ptr_phys & GENMASK(31, 0);

I think problem is that we shift 1 by 32 bits in this case (31 - 0 + 1) and
that overflows the size of unsigned. So there is this corner case where 
it does not seem to work (or atleast outputs warning).

Thanks
Vivek
