Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765168Ab3DDWRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:17:43 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:42263 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765150Ab3DDWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:17:41 -0400
Subject: Re: [RFC-v3 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Alexander Nezhinsky <alexandern@mellanox.com>
In-Reply-To: <515D4BD5.7020107@mellanox.com>
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
	 <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
	 <515D4BD5.7020107@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Apr 2013 15:17:27 -0700
Message-ID: <1365113847.11833.78.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 12:45 +0300, Or Gerlitz wrote:
> On 04/04/2013 10:24, Nicholas A. Bellinger wrote:
> 
> > +#define ISER_RECV_DATA_SEG_LEN  8192
> > +#define ISER_RX_PAYLOAD_SIZE    (ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
> > [...]
> > +#define ISER_RX_PAD_SIZE	(16384 - (ISER_RX_PAYLOAD_SIZE + \
> > +					sizeof(u64) + sizeof(struct ib_sge)))
> 
> We're eating here too much ram for the pad, you need 8K + something, so 
> the pad can count down
> from 12K and not 16K which means each such element will consume three 
> pages and not four.
> 

Hmm, IIRC this larger pad was originally required after bumping the
ISER_RECV_DATA_SEG_LEN value for handling incoming ImmediateData and
Unsolicited Data-OUT..  Will try using 12k here and see what happens..

Also, ISER_RECV_DATA_SEG_LEN will need to be enforced as the largest
MaxRecvDataSegmentLength negotiated during iser login to prevent the
initiator from exceeding the hardcoded value..

> > +struct iser_rx_desc {
> > +	struct iser_hdr iser_header;
> > +	struct iscsi_hdr iscsi_header;
> > +	char		data[ISER_RECV_DATA_SEG_LEN];
> > +	u64		dma_addr;
> > +	struct ib_sge	rx_sg;
> > +	char		pad[ISER_RX_PAD_SIZE];
> > +} __packed;
> > +
> > +struct isert_rx_desc {
> > +	struct isert_conn	*desc_conn;
> > +	struct work_struct	desc_work;
> > +	struct iser_rx_desc	desc;
> > +} __packed;
> 
> You have way enough room in the pad field of struct iser_rx_desc to 
> place there the two fields
> added by struct isert_rx_desc (and you only use struct iser_rx_desc from 
> within isert_rx_desc) --> any reason
> not to unify  them?
> 

This is left-over cruft from the per isert_rx_desc dispatch into process
context..  Dropping this now.

--nab

