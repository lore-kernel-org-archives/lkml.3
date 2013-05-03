Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763951Ab3ECXid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:38:33 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:47822 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3ECXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:38:31 -0400
Message-ID: <1367624456.21785.2.camel@haakon3.risingtidesystems.com>
Subject: Re: [RFC-v4 7/9] iscsi-target: Refactor TX queue logic + export
 response PDU creation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>,
        Alexander Nezhinsky <alexandern@mellanox.com>
Date: Fri, 03 May 2013 16:40:56 -0700
In-Reply-To: <CAMuHMdWVpF9G2v5oSYL642mpWdQCMGBhSQYa=Zw0s9DyoNJLjQ@mail.gmail.com>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
	 <1365799962-13543-8-git-send-email-nab@linux-iscsi.org>
	 <CAMuHMdWVpF9G2v5oSYL642mpWdQCMGBhSQYa=Zw0s9DyoNJLjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 23:04 +0200, Geert Uytterhoeven wrote:
> Hi Nicholas,
> 
> On Fri, Apr 12, 2013 at 10:52 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> 
> >  static int iscsit_send_reject(
> >         struct iscsi_cmd *cmd,
> >         struct iscsi_conn *conn)
> > @@ -3505,18 +3548,9 @@ static int iscsit_send_reject(
> >         struct iscsi_reject *hdr;
> >         struct kvec *iov;
> >
> > -       hdr                     = (struct iscsi_reject *) cmd->pdu;
> 
> Woops, and now hdr is no longer initialized:
> 
> drivers/target/iscsi/iscsi_target.c: In function ‘iscsit_send_reject’:
> drivers/target/iscsi/iscsi_target.c:3577: warning: ‘hdr’ is used
> uninitialized in this function
> 
> > -       hdr->opcode             = ISCSI_OP_REJECT;
> > -       hdr->flags              |= ISCSI_FLAG_CMD_FINAL;
> > -       hton24(hdr->dlength, ISCSI_HDR_LEN);
> > -       hdr->ffffffff           = cpu_to_be32(0xffffffff);
> > -       cmd->stat_sn            = conn->stat_sn++;
> > -       hdr->statsn             = cpu_to_be32(cmd->stat_sn);
> > -       hdr->exp_cmdsn  = cpu_to_be32(conn->sess->exp_cmd_sn);
> > -       hdr->max_cmdsn  = cpu_to_be32(conn->sess->max_cmd_sn);
> > +       iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd->pdu[0]);
> 
> Hence it will crash later:
> 
>                 iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
>                                 (unsigned char *)hdr, ISCSI_HDR_LEN,
>                                 0, NULL, (u8 *)header_digest);
> 
> and
> 
>         pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
>                 " CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);
> 

Whoops.  Applying the following patch to fix this up now, and including
in the next PULL request.

Thanks alot for catching this!

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index ffbc6a9..c230eac 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3557,11 +3557,11 @@ static int iscsit_send_reject(
        struct iscsi_cmd *cmd,
        struct iscsi_conn *conn)
 {
-       u32 iov_count = 0, tx_size = 0;
-       struct iscsi_reject *hdr;
+       struct iscsi_reject *hdr = (struct iscsi_reject *)&cmd->pdu[0];
        struct kvec *iov;
+       u32 iov_count = 0, tx_size;
 
-       iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd->pdu[0]);
+       iscsit_build_reject(cmd, conn, hdr);
 
        iov = &cmd->iov_misc[0];
        iov[iov_count].iov_base = cmd->pdu;


