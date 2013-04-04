Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986Ab3DDPYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:24:40 -0400
Received: from mx2.parallels.com ([199.115.105.18]:44604 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761549Ab3DDPYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:24:38 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Apr 2013 11:24:38 EDT
From: James Bottomley <jbottomley@parallels.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: scanning for LUNs
Thread-Topic: scanning for LUNs
Thread-Index: AQHOMUctLbBJHCoFOk22/89ZTQXv0Q==
Date: Thu, 4 Apr 2013 15:15:01 +0000
Message-ID: <1365088500.2764.8.camel@dabdike>
References: <1365088357-22624-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1365088357-22624-1-git-send-email-kys@microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [87.213.44.130]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B4B43BB0144F154C8C05F0B446C514CA@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 08:12 -0700, K. Y. Srinivasan wrote:
> Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.c in function 
> __scsi_scan_target()):
> 
>         /*
>          * Scan LUN 0, if there is some response, scan further. Ideally, we
>          * would not configure LUN 0 until all LUNs are scanned.
>          */
>         res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
>         if (res == SCSI_SCAN_LUN_PRESENT || res == SCSI_SCAN_TARGET_PRESENT) {
>                 if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
>  
> 
> So, if we don't get a response while scanning LUN0, we will not use
> scsi_report_lun_scan().
> On Hyper-V, the scsi emulation on the host does not treat LUN0 as
> anything special and we 
> could have situations where the only device under a scsi controller is
> at a location other than 0
> or 1. In this case the standard LUN scanning code in Linux fails to
> detect this device. Is this
> behaviour expected? Why is LUN0 treated differently here. Looking at
> the scsi spec, I am not sure
> if this is what is specified. Any help/guidance will be greatly
> appreciated.

Why don't you describe the problem.  We can't scan randomly a bunch of
LUNs hoping for a response (the space is 10^19).  SAM thinks you use
LUNW for this, but that's not well supported.  We can't annoy USB
devices by probing with REPORT LUNS, so conventionally most arrays
return something for LUN0 even if they don't actually have one (That's
what the peripheral qualifier codes are supposed to be about).  We
translate PQ1 and PQ2 to SCSI_SCAN_TARGET_PRESENT, which means no LUN,
but there is a target to scan here.

If you're sending back an error to an INQUIRY to LUN0, then you're out
of spec.  The SCSI standards say:

        SPC3 6.4.1: In response to an INQUIRY command received by an
        incorrect logical unit, the SCSI target device shall return the
        INQUIRY data with the peripheral qualifier set to the value
        defined in 6.4.2. The INQUIRY command shall return CHECK
        CONDITION status only when the device server is unable to return
        the requested INQUIRY data

James


James

