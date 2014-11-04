Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaKDOSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:18:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:58788 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaKDOSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:18:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616838316"
Message-ID: <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
From: Matt Fleming <matt.fleming@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        "Sam Protsenko" <semen.protsenko@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Date: Tue, 4 Nov 2014 14:18:08 +0000
In-Reply-To: <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
	 <20141104043247.GA23418@kroah.com>
	 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
	 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 22:32 -0800, Andy Lutomirski wrote:
> 
> It seems like a large fraction of the code in this module exists just
> to work around the fact that request_firmware doesn't do what you want
> it to do.  You have code to:
> 
>  - Prevent the /lib/firmware mechanism from working.
>  - Avoid a deadlock by doing strange things in the unload code.
>  - Allow more than one capsule per module load.  (Isn't this hard to
> use?  User code will have to wait for the next firmware request before
> sending a second capsule.)
> 
> All of this is for dubious gain.  You have to do three separate opens
> in sysfs to upload a capsule, and there's no way to report back to
> userspace whether the EFI call worked and whether a reboot is needed.

Whether or not a reboot is required is indicated in the capsule image
itself, i.e. the capsule tells the firmware whether an immediate reboot
is required not the other way around.

The firmware does tell the kernel what *kind* of a reboot is required,
but that doesn't need reporting to userspace.

> What's the benefit of using the firmware interface here?

I originally implemented something to send capsules to the firmware via
sysfs files back in 2013 and I basically ended up duplicating 25% of the
code that's already in drivers/base/firmware_class.c.

If you're objecting to the lack of modularity in firmware_class.c, then
we could probably carve up the functionality we require a little more
neatly (like not having to do the /lib/firmware avoidance hacks), but
firmware_class.c should definitely be used as the foundation.

