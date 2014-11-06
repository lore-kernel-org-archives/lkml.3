Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaKFQwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:52:39 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35801 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaKFQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B80F3A9@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com> <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com> <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80F3A9@PGSMSX102.gar.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 6 Nov 2014 08:52:13 -0800
Message-ID: <CALCETrUi0ssZbOpHyVmh6jx68Oj=0h4BwfM0uLio8Qbaeu9gJw@mail.gmail.com>
Subject: RE: [PATCH v2 3/3] efi: Capsule update with user helper interface
To: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Ming Lei <ming.lei@canonical.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2014 4:56 AM, "Kweh, Hock Leong" <hock.leong.kweh@intel.com> wrote:
>
> > -----Original Message-----
> > From: Andy Lutomirski [mailto:luto@amacapital.net]
> > Sent: Wednesday, November 05, 2014 12:36 AM
> >
> > Am I missing something here?  The current proposal is missing the
> > success/failure part, unless you count the loaded count (in a different sysfs
> > directory) as a useful interface for that.
>
> Here is my sample shell script which allow me to do multi capsule binaries upload
> and obtain error message if error occur:
>
> #!/bin/sh
>
> old=$(cat /sys/devices/platform/efi_capsule_user_helper/capsule_loaded)
>
> for arg in "$@"
> do
>         if [ -f $arg ]
>         then
>                 echo 1 > /sys/class/firmware/efi-capsule-file/loading
>                 cat $arg > /sys/class/firmware/efi-capsule-file/data
>                 echo 0 > /sys/class/firmware/efi-capsule-file/loading

I think you have a race.  Try putting msleep(1000) after the
request_firmware_nowait call, and I bet this will fail on the second
try.

>
>                 oldtime=$(date +%S)
>                 oldtime=$(((time + 2) % 60))
>                 until [ -f /sys/class/firmware/efi-capsule-file/loading ]
>                 do
>                         newtime=$(date +%S)
>                         if [ $newtime -eq $oldtime ]
>                         then
>                                 break
>                         fi
>                 done
>
>                 old=$((old + 1))
>                 new=$(cat /sys/devices/platform/efi_capsule_user_helper/capsule_loaded)

I think that firmware_class doesn't call the callback until after
loading is closed for the second time.  If so, then this is racy.  Try
inserting msleep(1000) at the beginning of your callback and uploading
a capsule that should load successfully -- this will report failure,
but a future upload may get very confused.  Also, what does the
firmware class do when simultaneous uploads of the same file with
different contents are in flight?  Is that possible?


--Andy
