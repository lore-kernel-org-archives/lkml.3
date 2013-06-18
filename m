Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3FRNDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:03:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57105 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3FRNDs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Tue, 18 Jun 2013 09:03:48 -0400
Message-Id: <51C068C1020000780009C995@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 18 Jun 2013 14:03:45 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <zacharyb@ami.com>, <matt@console-pimps.org>
Cc: <matt.fleming@intel.com>, <mjg59@srcf.ucam.org>,
        "Joey Lee" <JLee@suse.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: RE: [PATCH] x86, efi: retry ExitBootServices() on failure
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
 <20130617123052.GE8569@console-pimps.org>
 <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
In-Reply-To: <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Zachary Bobroff <zacharyb@ami.com> 06/18/13 2:25 AM >>>
> We only need to retry once because of what is in the UEFI specification 2.3.1 Errata
> C.  The exact verbiage is as follows:
>
> The ExitBootServices() function is called by the currently executing EFI OS loader
> image to terminate all boot services. On success, the loader becomes responsible for
> the continued operation of the system. All events of type EVT_SIGNAL_EXIT_BOOT_SERVICES
> must be signaled before ExitBootServices() returns EFI_SUCCESS. The events are
> only signaled once even if ExitBootServices() is called multiple times.
>
> Since the firmware will only signal the ExitBootServices event once, the code that
> has the potential to change the memory map will only be signaled on the first call to
> exit boot services.

Okay, I'm fine with that aspect then. Let's hope everyone plays by that rule.

> Here is the logic for why we need space for the two additional Efi Memory Map
> Descriptors is as follows:
> First, we should think of the size that is returned from the GetMemoryMap as being
> the number of bytes to contain the current memory map.  Once we have the size of
> the current memory map, we, the kernel, have to perform an allocation of memory
> so that we can store the current memory map into some memory that will not be
> overwritten. That allocation has the possibility of increasing the current memory
> map count by one efi_memory_desc_t structure.

Why by one? Splitting some 'free memory' block may result in an increase by more
then one afaict. Assuming the increment can only be one is implying you having
knowledge of the allocator implementation and behavior, which shouldn't be made
use of in kernel code.

Jan

