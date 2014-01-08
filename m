Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaAHPAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:00:49 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:34962 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbaAHPAp (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 8 Jan 2014 10:00:45 -0500
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
In-Reply-To: <52CC2CDF.3000100@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>
	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>
	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>
	 <52CC2CDF.3000100@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jan 2014 22:59:02 +0800
Message-ID: <1389193142.3539.6123.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2014-01-07 於 08:35 -0800，H. Peter Anvin 提到：
> On 01/07/2014 02:40 AM, joeyli wrote:
> > 
> > Due to accessing CMOS through ASL need enable SMM support in OVMF,
> 
> Why?  The CMOS is its own ASL address space, and you need that anyway to
> be able to access the RTC proper.  If you don't want to use it because
> you don't want to export any indication of a legacy RTC you should be
> able to just do I/O port references directly in your ASL.
> 
> 	-hpa
> 
> 

ACPICA denied AML access RTC ports.

I tried to access 0x70, 0x71 ports in ASL on a real machine, ACPICA
denied AML access to those ports. I got the following dmesg:

hwvalid-0188 hw_validate_io_request: Denied AML access to port
0x0000000000000071/1


The code in acpica denied it:

linux/drivers/acpi/acpica/hwvalid.c

 * This provides ACPICA with the desired port protections and
 * Microsoft compatibility.
 *
 * Description of port entries:
[...]
 *  RTC:   Real-time clock
 *  CMOS:  Extended CMOS
[...]
 */
static const struct acpi_port_info acpi_protected_ports[] = {
[...]
        {"RTC", 0x0070, 0x0071, ACPI_OSI_WIN_XP},
        {"CMOS", 0x0074, 0x0076, ACPI_OSI_WIN_XP},


Document of Windows XP:
http://www.freelists.org/post/windows_errors/what-error-messages-really-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP


If just for ACPI TAD testing, we can remove the port protection check of
RTC ports in hwvalid.c. I have read 0x70/0x71 port success after removed
the checking in acpica/hwvalid.c.

I will try to write RTC port in AML after remove acpica check, maybe
have other unpredictable situation.


Thanks a lot!
Joey Lee

