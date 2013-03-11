Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3CKIp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab3CKIp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:45:27 -0400
Message-ID: <513D9998.5030106@redhat.com>
Date: Mon, 11 Mar 2013 16:45:12 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_net: remove tx polling state
References: <1362630716-57674-1-git-send-email-jasowang@redhat.com> <20130310165030.GA13687@redhat.com> <513D8316.90907@redhat.com> <20130311082923.GB21086@redhat.com>
In-Reply-To: <20130311082923.GB21086@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 04:29 PM, Michael S. Tsirkin wrote:
> On Mon, Mar 11, 2013 at 03:09:10PM +0800, Jason Wang wrote:
>> On 03/11/2013 12:50 AM, Michael S. Tsirkin wrote:
>>> On Thu, Mar 07, 2013 at 12:31:56PM +0800, Jason Wang wrote:
>>>> After commit 2b8b328b61c799957a456a5a8dab8cc7dea68575 (vhost_net: handle polling
>>>> errors when setting backend), we in fact track the polling state through
>>>> poll->wqh, so there's no need to duplicate the work with an extra
>>>> vhost_net_polling_state. So this patch removes this and make the code simpler.
>>>>
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>> I'd prefer a more radical approach, since I think it can be even
>>> simpler: tap and macvtap backends both only send events when tx queue
>>> overruns which should almost never happen.
>>>
>>> So let's just start polling when VQ is enabled
>>> drop all poll_start/stop calls on data path.
>> I think then it may damage the performance at least for tx. We
>> conditionally enable the tx polling in the past to reduce the
>> unnecessary wakeups of vhost thead when zerocopy or sndbuf is used. If
>> we don't stop the polling, after each packet were transmitted,
>> tap/macvtap will try to wakeup the vhost thread.
> It won't actually.
> static void macvtap_sock_write_space(struct sock *sk)
> {
>         wait_queue_head_t *wqueue;
>
>         if (!sock_writeable(sk) ||
>             !test_and_clear_bit(SOCK_ASYNC_NOSPACE, &sk->sk_socket->flags))
>                 return;
>
>         wqueue = sk_sleep(sk);
>         if (wqueue && waitqueue_active(wqueue))
>                 wake_up_interruptible_poll(wqueue, POLLOUT | POLLWRNORM | POLLWRBAND);
> }
>
> As long as SOCK_ASYNC_NOSPACE is not set, there's no wakeup.
>

Ok, will send V2 which removes all the polling start/stop in datapath.

Thanks
