Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab3DNGGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:06:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43383 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750766Ab3DNGGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:06:15 -0400
Message-ID: <1365919574.1878.13.camel@joe-AO722>
Subject: arch/s390/lib/uaccess_pt.c: Missing breaks: ?
From: Joe Perches <joe@perches.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 13 Apr 2013 23:06:14 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Heiko.

Commit ea81531d ("s390/uaccess: fix page table walk")
added this code.  It looks like it should have break;
for each case.

------------

static unsigned long follow_table(struct mm_struct *mm,
				  unsigned long address, int write)
{
	unsigned long *table = (unsigned long *)__pa(mm->pgd);

	switch (mm->context.asce_bits & _ASCE_TYPE_MASK) {
	case _ASCE_TYPE_REGION1:
		table = table + ((address >> 53) & 0x7ff);
		if (unlikely(*table & _REGION_ENTRY_INV))
			return -0x39UL;
		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
	case _ASCE_TYPE_REGION2:
		table = table + ((address >> 42) & 0x7ff);
		if (unlikely(*table & _REGION_ENTRY_INV))
			return -0x3aUL;
		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
	case _ASCE_TYPE_REGION3:
		table = table + ((address >> 31) & 0x7ff);
		if (unlikely(*table & _REGION_ENTRY_INV))
			return -0x3bUL;
		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
	case _ASCE_TYPE_SEGMENT:
		table = table + ((address >> 20) & 0x7ff);
		if (unlikely(*table & _SEGMENT_ENTRY_INV))
			return -0x10UL;
		if (unlikely(*table & _SEGMENT_ENTRY_LARGE)) {
			if (write && (*table & _SEGMENT_ENTRY_RO))
				return -0x04UL;
			return (*table & _SEGMENT_ENTRY_ORIGIN_LARGE) +
				(address & ~_SEGMENT_ENTRY_ORIGIN_LARGE);
		}
		table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);
	}


