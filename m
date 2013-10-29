Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3J2Ixt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:53:49 -0400
Received: from mitrol.it ([82.188.252.170]:56066 "EHLO mail.mitrol.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3J2Ixq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:53:46 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 04:53:46 EDT
Message-ID: <526F7568.2050300@mitrol.it>
Date: Tue, 29 Oct 2013 09:44:24 +0100
From: Paolo Minazzi <Paolo.Minazzi@mitrol.it>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bug in generic_access_phys (mm/memory.c) ?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 131028-1, 28/10/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to all,
I think the function "generic_access_phys" in mm/memory.c has got a 
small bug.
THe ioremap_prot is called with the parameter size=PAGE_SIZE.
But it can happen that we need more than one page, and this will produce 
a kernel fault.

int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
                         void *buf, int len, int write)
{
         resource_size_t phys_addr;
         unsigned long prot = 0;
         void __iomem *maddr;
         int offset = addr & (PAGE_SIZE-1);

         if (follow_phys(vma, addr, write, &prot, &phys_addr))
                 return -EINVAL;

====>   maddr = ioremap_prot(phys_addr, PAGE_SIZE);

         if (write)
                 memcpy_toio(maddr + offset, buf, len);
         else
                 memcpy_fromio(buf, maddr + offset, len);
         iounmap(maddr);

         return len;
}


I think that the ioremap_prot should be changed with

maddr = ioremap_prot(phys_addr, ((phys_addr + offset + len - 1) & 
~(PAGE_SIZE-1)) -
                                 phys_addr + PAGE_SIZE);

Thanks,
Paolo Minazzi



