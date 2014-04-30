Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243AbaD3V6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:58:01 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63632 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbaD3V6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:58:00 -0400
Message-ID: <53617140.6060206@kernel.dk>
Date: Wed, 30 Apr 2014 15:55:12 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com
Subject: Re: [PATCH 00/24] RFC: DRBD Fixes and REQ_DISCARD support
References: <1398703415-17780-1-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1398703415-17780-1-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 10:43 AM, Philipp Reisner wrote:
> This patch series contains these new features for DRBD:
>  * Support for REQ_DISCARD
>  * Allow parallel promote/demote
>  * Allow online changing of al-stripes and al-stripe-size with the
>    resize command
> 
> and contains fixes for these issues:
>  * fix potential deadlock when concurrently fencing and establishing a connection
>  * fix potential distributed deadlock during verify or resync
>  * fix decoding of bitmap vli rle for device sizes > 64 TB
>  * fix for deadlock when using automatic split-brain-recovery
>  * only fail empty flushes if no good data is reachable
>  * avoid to shrink max_bio_size due to peer re-configuration
>  * fix resume-io after reconnect with broken fence-peer handler
>  * fix too large bursts for very slow resync rates
>  * don't let application IO throttle resync to a stall
>  * Fixed a hole in the challenge-response implementation
>  * Fixed a theoretical IO deadlock (Only triggers with unusual small AL i.e. 7)
>  * Fixed attaching to disks with fixed size external meta-data
>    (This regressions was introduced with 8.4.3)
>  * Fixed a crash when the connection broke at a very exact point in
>    time while a graceful disconnect executes
> 
> Lars Ellenberg (15):
>   drbd: fix stalled resync detection in /proc/drbd
>   drbd: resync: fix too large bursts for very slow rates
>   drbd: fix potential distributed deadlock during verify or resync
>   drbd: don't let application IO pre-empt resync too often
>   drbd: perpare for genetlink parallel_ops
>   drbd: allow parallel promote/demote actions
>   drbd: prepare receiving side for REQ_DISCARD
>   drbd: prepare sending side for REQ_DISCARD
>   drbd: Enable QUEUE_FLAG_DISCARD only if the peer can recieve P_TRIM
>   drbd: fix a race between start_resync and send_and_submit
>   drbd: keep max-bio size during detach/attach on disconnected primary
>   drbd: add back some fairness to AL transactions
>   drbd: always implicitly close last epoch when idle
>   drbd: evaluate disk and network timeout on different requests
>   drbd: use list_first_entry_or_null in first_peer_device/first_connection
> 
> Philipp Reisner (9):
>   drbd: Break a deadlock while concurrent fencing and establishing a connection
>   drbd: Leave IO suspended if the fence handler find the peer primary
>   drbd: Remove drbd_wrappers.h
>   drbd: Allow online layout change of AL while peer is not connected
>   drbd: Do not BUG() when connection breaks in a special way
>   drbd: Fix a hole in the challange-response connection authentication
>   drbd: use blk_set_stacking_limits()
>   drbd: Test cstate while holding req_lock
>   drbd: Allow attaching of a newly created device to any backing device
> 
>  drivers/block/drbd/drbd_actlog.c   |  23 +-
>  drivers/block/drbd/drbd_int.h      |  92 ++++++-
>  drivers/block/drbd/drbd_main.c     |  28 ++-
>  drivers/block/drbd/drbd_nl.c       | 485 ++++++++++++++++++++++---------------
>  drivers/block/drbd/drbd_nla.c      |   1 -
>  drivers/block/drbd/drbd_proc.c     |   2 +-
>  drivers/block/drbd/drbd_protocol.h |  12 +
>  drivers/block/drbd/drbd_receiver.c | 196 ++++++++++-----
>  drivers/block/drbd/drbd_req.c      |  74 ++++--
>  drivers/block/drbd/drbd_req.h      |   6 +-
>  drivers/block/drbd/drbd_state.c    |  38 +--
>  drivers/block/drbd/drbd_worker.c   | 107 ++++----
>  drivers/block/drbd/drbd_wrappers.h |  54 -----
>  13 files changed, 701 insertions(+), 417 deletions(-)
>  delete mode 100644 drivers/block/drbd/drbd_wrappers.h

Added for 3.16, thanks.


-- 
Jens Axboe

