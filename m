Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaGBSFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaGBSFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:05:47 -0400
Date: Wed, 2 Jul 2014 14:05:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Sagi Grimberg <sagig@mellanox.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Crash on WRITE SAME
Message-ID: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sagi

Your commit d77e65350f2d82dfa0557707d505711f5a43c8fd causes crash on SCSI 
WRITE SAME command (it can be triggered by issuing the BLKZEROOUT ioctl). 
The crash happens in iscsi_tcp_segment_done because sg_next returns NULL.

Before that commit, there was this code in iscsi_prep_scsi_cmd_pdu:
	unsigned out_len = scsi_out(sc)->length;
after the commit, there is this:
	transfer_length = scsi_transfer_length(sc);
	... scsi_transfer_length(struct scsi_cmnd *scmd) returns 
	    blk_rq_bytes(scmd->request);

The problem is this: suppose that we have WRITE_SAME command that writes 
two 512-byte sectors. blk_rq_bytes(scmd->request) returns 1024 (because 
1024 bytes are written to the disk), but scsi_out(sc)->length contains the 
value 512 (because only 512 bytes are transferred as data for the SCSI 
command).

Your patch changes that from 512 to 1024 and it causes the crash in 
iscsi_tcp_segment_done due to mismatching size.



I'm not exactly sure how to fix this bug in order to not break something 
else.

I'd like to know what was your intention for the function 
scsi_transfer_length? Is it supposed to return the size of data 
transferred on the SCSI bus? What should it return for bidirectional 
commands?

scsi_transfer_length tries to add 8 for each transferred sector depending 
on prot_op. What should it do with commands that transfer only part of a 
sector? (for example the UNMAP command only transfers 24 bytes of data). 
Should it add 8 for a partial sector tranferred or not?

Mikulas
