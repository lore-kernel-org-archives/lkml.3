Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLPIEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:04:11 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:35244 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaLPIEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:04:09 -0500
Message-ID: <1418717046.5431.82.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] iscsi-target: Fail connection on short writes/reads
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 16 Dec 2014 00:04:06 -0800
In-Reply-To: <20141216060417.GY22149@ZenIV.linux.org.uk>
References: <1418705338-23695-1-git-send-email-nab@daterainc.com>
	 <20141216060417.GY22149@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 06:04 +0000, Al Viro wrote:
> On Tue, Dec 16, 2014 at 04:48:58AM +0000, Nicholas A. Bellinger wrote:
> 
> > In practice this has not been an issue because iscsit_do_tx_data()
> > is only used for transferring 48 byte headers + 4 byte digests,
> > along with seldom used control payloads from NOPIN + TEXT_RSP +
> > REJECT with less than 32k of data.  Nor has it been occuring with
> > iscsit_do_rx_data() because MSG_WAITALL won't return to caller
> > until the requested transfer length is reached, or an error has
> > occured.
> > 
> > So following Al's audit of iovec consumers, go ahead and fail
> > the connection on short writes/reads for now, and remove the
> > bogus logic.
> 
> Umm...  This won't apply anymore.  For one thing, rscvmsg path in mainline
> doesn't use kernel_recvmsg() - not since
> commit e5a4b0bb803b39a36478451eae53a880d2663d5b
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Mon Nov 24 18:17:55 2014 -0500
> 
>     switch memcpy_to_msg() and skb_copy{,_and_csum}_datagram_msg() to primitives
> 
> That code has already become
>         memset(&msg, 0, sizeof(struct msghdr));
>         iov_iter_kvec(&msg.msg_iter, READ | ITER_KVEC,
>                       count->iov, count->iov_count, data);
> 
>         while (total_rx < data) {
>                 rx_loop = sock_recvmsg(conn->sock, &msg,
>                                       (data - total_rx), MSG_WAITALL);
>                 if (rx_loop <= 0) {
>                         pr_debug("rx_loop: %d total_rx: %d\n",
>                                 rx_loop, total_rx);
>                         return rx_loop;
>                 }
>                 total_rx += rx_loop;
>                 pr_debug("rx_loop: %d, total_rx: %d, data: %d\n",
>                                 rx_loop, total_rx, data);
>         }
> 
> with short reads dealt with just fine - we set ->msg_iter once and each
> call of sock_recvmsg() (which doesn't need set_fs() anymore) advances
> it for the amount actually received.

Ah, didn't realize this was already merged.  Dropping this part now.

Thanks for getting this addressed in -rc1 code btw.  ;)

> 
> sendmsg() side is trivially dealt with in the same fashion.  I haven't
> pushed that into vfs#iov_iter-net yet, but as soon as the davem opens
> net-next I'll be posting the sendmsg part of the series for review and
> this will go there as well.

Your planning to push the iscsit_do_tx_data() changes post -rc1,
right..?

>   FWIW, right now it looks thus:
> 
>         iov_iter_kvec(&msg.msg_iter, WRITE | ITER_KVEC,
>                       count->iov, count->iov_count, data);
>         while (msg_data_left(&msg)) {
>                 tx_loop = sock_sendmsg(conn->sock, &msg);
>                 if (tx_loop <= 0) {
>                         pr_debug("tx_loop: %d total_tx %d\n",
>                                 tx_loop, total_tx);
>                         return tx_loop;
>                 }
>                 total_tx += tx_loop;
>                 pr_debug("tx_loop: %d, total_tx: %d, data: %d\n",
>                                         tx_loop, total_tx, data);
>         }
> 
> (msg_data_left(msg) == iov_iter_count(&msg->msg_iter) and sock_sendmsg()
> has lost the third argument - it was always equal to msg_data_left(msg)).
> 
> iovec is never drained, ->msg_iter is always advanced by the amount actually
> sent.  Makes (ex-)users of kernel_sendmsg()/kernel_recvmsg() much simpler
> and trivial way of handling short writes/reads becomes correct...
> --

So what do you want to do for the existing (potential) bug in
iscsit_do_tx_data()? 

Do you prefer the tx change goes via target-pending for <= -rc1 +
stable, ahead of your proper sendmsg series for -rc2 code..?

--nab

