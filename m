Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3KVBF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:05:27 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:14019 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KVBFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:05:24 -0500
Date: Thu, 21 Nov 2013 18:05:15 -0700
From: jerry.hoemann@hp.com
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131122010515.GG1106@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <20131121233104.GF1106@anatevka.fc.hp.com>
 <20131121233831.GB32121@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121233831.GB32121@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:38:31PM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 04:31:04PM -0700, jerry.hoemann@hp.com wrote:
> 
> > I tried this back on 3.11 kernel and reserve_crashkernel after free of
> > boot services failed.  I will admit to not digging in too deeply as to
> > why it failed.
> 
> Hm. If the problem is fragmentation, then yeah, I can imagine this 
> causing problems. In that case we could take a two-pass approach - find 
> a gap that *will* be big enough, reserve everything that isn't currently 
> reserved, and then reserve the rest after ExitBootServices()?


Matthew,

Did you really mean EnterVirtualMode (not ExitBootServices?)

One of the difficulties i'm having is that distros and stable releases
want fixes upstream that they just back port.

ExitBootServices is called in different locations dependent upon
release.  The current use is to have linux do ExitBootServices, whereas
EBS used to be done in the boot loaders.  So, i'm concerned that 
such an approach might require legacy boot loader changes.  That would
be a difficult sell.

But,  splitting up what is done where may work.

While the crash kernel space is reserved early in boot,  i don't believe
it is written to until much later (kexec_load??)  So, i don't believe that
we'd loose any boot code/data that might be missed by firmware that tried
to access after ExitBootService.

In one of your earlier emails you mentioned the issue is that linux makes
regions NX.  That would cause problems if FW tried to execute a region
we just reserved.  Unfortunately, i'm not seeing where the kernel is
doing this for crash kernel memory.  Assuming it is making it NX, can
we defer that part?  Or if its not, do we have a problem w/ crash kernel
reservation at all?

Interesting questions, but as I don't have access to a system that has
the firmware defects encountered when efi_reserve_boot_services, it makes
it difficult to test that i don't break them.  Hence, the appealing nature
of quirks.  Don't have to worry about breaking other platforms as they
continue to operate same as before.

I can understand the desire some have to not introducing quirks.
They can be like potato chips.  You can't have just one.  :)  :)



-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

