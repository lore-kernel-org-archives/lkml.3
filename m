Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaAOWjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:39:19 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:37118 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaAOVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:27 -0500
Message-ID: <1389822920.5567.560.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3
 emulation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: sagi grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Date: Wed, 15 Jan 2014 13:55:20 -0800
In-Reply-To: <52D6CD70.20706@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <52D6CD70.20706@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 20:03 +0200, sagi grimberg wrote:
> On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > Hi MKP & SCSI folks,
> >
> > This series contains initial support for target mode DIF Type1+Type3
> > emulation within target core, RAMDISK_MCP device backend, and tcm_loop
> > fabric driver.
> >
> > DIF emulation is enabled via a new 'pi_prot_type' device attribute
> > within configfs, which is set after initial device configuration and
> > before target fabric LUN export occurs.
> >
> > The DIF read/write verify emulation has been made generic enough so
> > it can be used by other backend drivers (eg: FILEIO), as well as
> > DIF v2 in the near future.  Also note that the majority of the logic
> > has been groked from existing scsi_debug.c code.
> >
> > The current plan is to enable basic support for emulated backends with
> > tcm_loop for v3.14 code, and then move onto IBLOCK backend support
> > (that requires BLOCK layer changes)
> 
> Hey Nic,
> Can you please elaborate on what BLOCK layer changes are required?
> I didn't spot any misses from Looking at 
> Documentation/block/data-integrity.txt.
> 
> Am I missing something?

The issue is that existing fs/bio-integrity.c code always assumes
client/initiator mode, in that it will attempt to
bio_integrity_generate() protection information in the submit_bio WRITE
path, and bio_integrity_verify() of protection information in the
bio_endio READ completion path.

So we'll need a server/target passthrough mode where existing protection
information can be attached during bio setup in IBLOCK code, and the
response be propagated back up without the extra verify, including
propagating up potential Guard + Reference tag failures to the original
submit_bio() caller.

--nab

