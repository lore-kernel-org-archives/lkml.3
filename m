Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3DMRj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:39:29 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:43858 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3DMRj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:39:28 -0400
Message-ID: <51699843.7060905@gmail.com>
Date: Sat, 13 Apr 2013 13:39:15 -0400
From: Kyle Evans <kvans32@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>  <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>
In-Reply-To: <1365870087.13667.7.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2013 12:21 PM, Matthew Garrett wrote:
> On Sat, 2013-04-13 at 08:36 -0400, Kyle Evans wrote:
>> Sure, sorry about that. I was hoping the GUID would be enough. I'll see
>> what I can come up with.
> Sure there's no WMI method that makes the EC write? It's a little weird
> for WMI drivers to have to hit the EC directly.
>
I have no idea, I didn't know what a DSDT was before trying to get these 
buttons working.

...A quick grep reveals acpi_wmi_ec_space_handler, is that what I should 
use? It calls ec_write itself, but has more function parameters and of 
course error checking to make sure you don't screw up those extra 
parameters. Seems inefficient to me. Or, maybe like it was designed for 
an automated code routine.

Looking further, I don't see any other drivers that use it, ec_write 
seems to be the standard.

Your call though, you are the master in this domain and you wrote the 
driver.



static acpi_status
acpi_wmi_ec_space_handler(u32 function, acpi_physical_address address,
                       u32 bits, u64 *value,
                       void *handler_context, void *region_context)
{
         int result = 0, i = 0;
         u8 temp = 0;

         if ((address > 0xFF) || !value)
                 return AE_BAD_PARAMETER;

         if (function != ACPI_READ && function != ACPI_WRITE)
                 return AE_BAD_PARAMETER;

         if (bits != 8)
                 return AE_BAD_PARAMETER;

         if (function == ACPI_READ) {
                 result = ec_read(address, &temp);
                 (*value) |= ((u64)temp) << i;
         } else {
                 temp = 0xff & ((*value) >> i);
                 result = ec_write(address, temp);
         }

         switch (result) {
         case -EINVAL:
                 return AE_BAD_PARAMETER;
                 break;
         case -ENODEV:
                 return AE_NOT_FOUND;
                 break;
         case -ETIME:
                 return AE_TIME;
                 break;
         default:
                 return AE_OK;
         }
}

