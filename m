Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3DTJte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 05:49:34 -0400
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:38301 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3DTJt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 05:49:29 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Apr 2013 05:49:28 EDT
Message-ID: <5172631E.6050305@corelatus.se>
Date: Sat, 20 Apr 2013 11:42:54 +0200
From: Thomas Lange <thomas@corelatus.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org
Subject: MIPS: c17a6554 broke 64BIT_PHYS_ADDR for 32 bit systems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ralf,

commit c17a6554 unintentionally(?) modified the PAGE_MASK type
from (int) to (long unsigned int).

This breaks ioremap (and possibly more) when using 64BIT_PHYS_ADDR on
32 bit systems.
Example of failing code from ioremap.c:

	phys_addr &= PAGE_MASK;

Since phys_addr is 64 bit (unsigned long long) when 64BIT_PHYS_ADDR and
PAGE_MASK is 32bit (long unsigned int), the upper 32 bits will always
be zeroed which is not what we want/expect.

The code above works if PAGE_MASK is a _signed_ 32bit int though.

Some possible fixes:

A) Simply revert the commit. Makes ioremap work again, but then PAGE_MASK
    is a signed int. Do we really want a mask that is 'signed'?

B) Don't use PAGE_MASK for physical addresses. x86 defines this:

   /* Cast PAGE_MASK to a signed type so that it is sign-extended if
      virtual addresses are 32-bits but physical addresses are larger
      (ie, 32-bit PAE). */
   #define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)

   Perhaps mips need something similar?


This is an issue with 3.8 and doesn't seem to be solved in master either.

Regards,
/Thomas
