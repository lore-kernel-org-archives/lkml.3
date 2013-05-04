Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078Ab3EDAOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 20:14:11 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:38612 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab3EDAOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 20:14:10 -0400
Message-ID: <1367626605.21785.10.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] iscsi-target: Make buf param of
 iscsit_do_crypto_hash_buf() const void *
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 03 May 2013 17:16:45 -0700
In-Reply-To: <CAMuHMdUOXbPkJf0Y1hupmmeotO6teFL1xJubRY0nBsTVu7=hBw@mail.gmail.com>
References: <1367615757-1447-1-git-send-email-geert@linux-m68k.org>
	 <CAMuHMdUOXbPkJf0Y1hupmmeotO6teFL1xJubRY0nBsTVu7=hBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 23:22 +0200, Geert Uytterhoeven wrote:
> On Fri, May 3, 2013 at 11:15 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> 
> > @@ -3585,9 +3575,8 @@ static int iscsit_send_reject(
> >         }
> >
> >         if (conn->conn_ops->DataDigest) {
> > -               iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> > -                               (unsigned char *)cmd->buf_ptr, ISCSI_HDR_LEN,
> > -                               0, NULL, (u8 *)&cmd->data_crc);
> > +               iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, cmd->buf_ptr,
> > +                               ISCSI_HDR_LEN, 0, NULL, (u8 *)&cmd->data_crc);
> 
> BTW, there are serious issues with casting pointers to u32s to pointers to u8s
> for the last two output parameters of iscsit_do_crypto_hash_buf() (pad_bytes
> and data_crc):
>   1. It's not endian-safe,
>   2. In many cases, the original u32 was not initialized at all, so the other 24
>       bits contain garbage. This will cause 32-bit comparisons like
> 
>         if (checksum != data_crc)
> 
>      to fail in unpredictable ways.
> 

Ugh, I can see how that would be problematic for BE..

Changing these to use u8 data_crc[ISCSI_DIGEST_SIZE] and
pad_bytes[ISCSI_PAD_LEN] now, and will post a patch soon.

Thanks again,

--nab


