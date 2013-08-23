Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3HWQ7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:59:22 -0400
Received: from mout.gmx.net ([212.227.17.21]:53524 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3HWQ7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:59:20 -0400
MIME-Version: 1.0
Message-ID: <trinity-5320947e-cb3a-48ad-813e-70ea78b657a4-1377277158706@3capp-gmx-bs46>
From: "Andreas Werner" <wernerandy@gmx.de>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Subject: Aw: Re: question about ioremap_cache and PAT
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Aug 2013 18:59:18 +0200 (CEST)
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K0:ip9uagZlR8kgsKM+LhyhAVj6mgf3F/xc1MQrM9mpnYE
 97CnBXqdq9l3sNTjGeDy6ePX3oU/z3l4gD2ZKqmM9ZuYgyREN7
 npruKTn2yusQ108QlClst5r43lmkmcmZl8bKCIFLhTfkCIwusf
 Kz/JAdTWupXNHXsxISvlChxJjLzhE8i/nd4JdgnnusXKnK9JIb
 vkhmyrniVgku9lTQC3azADvwOZlOrsSPDxf7GorkUiMmL/ZCnL
 apgiHfGCV3UvfA3fqqviIpHhmuAogAwgLrNZ0mMmiJEeep3wyN 1tERf0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,
thank you for your answer.
 
So we are two persons for now who need WT :-)
 
Im currently working on an ethernet driver for our own ETH core.
The problem is that one requirement is to not use DMA to transmit or receive the data.
This means the that the ethernet buffer are not located in the main memory. They are located in
the FPGA.
 
To transmit or receive a frame, i have to read or write to mmio to get the data.
 
Intel has introduced the command "clflush" which can flush a cache line.
I wanted to activate the caches for those mmio (eth buffer) to speed up the transmit or receive.
After that the transfer over PCIe uses burst read/write.
 
The problem was if i set the buffer to Write-Back and call clflush on those mmio-addresses, the system crashed without any output.
I found this articel http://software.intel.com/en-us/forums/topic/393070.[http://software.intel.com/en-us/forums/topic/393070]
 
After that i configured the transmit buffer to be Write-Combining (only write to that adresses) using ioremap_wc, and
the receive buffer to be Write-Through (ioremap_cache + mtrr Write-Back + my Kernel Hack :-)) everything worked fine.
The other configuration Register on the FPGA are just mapped with ioremap.
 
On PCIe Tracer i can see the burst read/write on my device.
 
Is it possible to get hits into the Kernel?
 
My modification in arch/x86/mm/pat.c:
 
--- pat.c.orig 2013-02-03 01:18:49.491879407 +0100
+++ pat.c 2013-02-03 01:19:19.053509836 +0100
@@ -149,10 +149,16 @@ static unsigned long pat_x_mtrr_type(u64
   u8 mtrr_type;
 
   mtrr_type = mtrr_type_lookup(start, end);
-  if (mtrr_type != MTRR_TYPE_WRBACK)
+
+  if (mtrr_type == MTRR_TYPE_WRTHROUGH) {
+   return _PAGE_CACHE_WB;
+  }
+  else if( mtrr_type == MTRR_TYPE_WRBACK )
+   return _PAGE_CACHE_WB;
+  else
    return _PAGE_CACHE_UC_MINUS;
- 
-  return _PAGE_CACHE_WB;
+
  }
 
  return req_type;
 
 
Best regards.
 

Gesendet: Montag, 12. August 2013 um 19:53 Uhr
Von: "Andy Lutomirski" <luto@amacapital.net>
An: "Andreas Werner" <wernerandy@gmx.de>
Cc: linux-kernel@vger.kernel.org
Betreff: Re: question about ioremap_cache and PAT
On 08/11/2013 09:50 AM, Andreas Werner wrote:
> Hi i have a question about ioremap_cache and the resulting PAT attribute on X86 system. If I configure the mtrr to Write-Through for an adress range, and call ioremap_cache to map the mmio, the resulting PAT attribute is set to UC.
> If I check the Intel document IA-32 SDM vol 3a, the resulting PAT attribute should be WB.
>
> I found the function pat_x_mtrr_type in arch/x86/mm/pat.c where the resulting attribute is returned. There will be always UC return expect if the MTRR is set to WB.
>
> Why is there only WB or UC returned? In the Intel document there are a lot of combinations "allowed".
>
> I need a Attribute of WT, so what i did is to modify the pat_x_mtrr_type function to return also WB if the MTRR is set to WT.
>
> Is this a solution to solve that or whats the reasion why the kernel doesn´t support this combination?

The kernel doesn't support it because I'm apparently the only person who
ever wanted it and I haven't implemented it yet.

This stuff is handled in hardware, so modifying the kernel's idea of
what hardware does won't do much. Also, the kernel using MTRRs is on
its (very slow) way out. You could probably hack something up, but I
can almost guarantee that hpa, etc won't accept the patches.

That being said, I'm planning to support WT directly using PAT in the
near future. This will work on most recent cpus (there are errata that
will prevent use of the high PAT entries on some cpus).

What do you need WT for? I want it for NVDIMMs, and all I need to get
started now is a heatsink*, so I'll hopefully start implementing this
stuff in the next week or so.

--Andy

* Damnit, Intel, it's not 2003 any more. You already figured out that
heatsinks want screw holes. But why couldn't you make sure that all
so-called "LGA 2011" sockets have the screw holes in the same place?


>
> Best regards
>
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> B
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> A
> B
> B
> B
> Best regards
>
 
