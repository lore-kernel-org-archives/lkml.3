Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3BKOX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:23:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab3BKOWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:41 -0500
Message-ID: <5118FEA9.2080201@redhat.com>
Date: Mon, 11 Feb 2013 15:22:33 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com>
In-Reply-To: <1360196636-9357-2-git-send-email-acking@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/13 01:23, Andy King wrote:
> +struct vsock_transport_recv_notify_data {
> +	u64 data1; /* Transport-defined. */
> +	u64 data2; /* Transport-defined. */
> +	bool notify_on_block;
> +};
> +
> +struct vsock_transport_send_notify_data {
> +	u64 data1; /* Transport-defined. */
> +	u64 data2; /* Transport-defined. */
> +};
> +
> +struct vsock_transport {
> +	/* Initialize/tear-down socket. */
> +	int (*init)(struct vsock_sock *, struct vsock_sock *);
> +	void (*destruct)(struct vsock_sock *);
> +	void (*release)(struct vsock_sock *);
> +
> +	/* Connections. */
> +	int (*connect)(struct vsock_sock *);
> +
> +	/* DGRAM. */
> +	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> +	int (*dgram_dequeue)(struct kiocb *kiocb, struct vsock_sock *vsk,
> +			     struct msghdr *msg, size_t len, int flags);
> +	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> +			     struct iovec *, size_t len);
> +	bool (*dgram_allow)(u32 cid, u32 port);
> +
> +	/* STREAM. */
> +	/* TODO: stream_bind() */
> +	ssize_t (*stream_dequeue)(struct vsock_sock *, struct iovec *,
> +				  size_t len, int flags);
> +	ssize_t (*stream_enqueue)(struct vsock_sock *, struct iovec *,
> +				  size_t len);
> +	s64 (*stream_has_data)(struct vsock_sock *);
> +	s64 (*stream_has_space)(struct vsock_sock *);
> +	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> +	bool (*stream_is_active)(struct vsock_sock *);
> +	bool (*stream_allow)(u32 cid, u32 port);
> +
> +	/* Notification. */
> +	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> +	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
> +	int (*notify_recv_init)(struct vsock_sock *, size_t,
> +		struct vsock_transport_recv_notify_data *);
> +	int (*notify_recv_pre_block)(struct vsock_sock *, size_t,
> +		struct vsock_transport_recv_notify_data *);
> +	int (*notify_recv_pre_dequeue)(struct vsock_sock *, size_t,
> +		struct vsock_transport_recv_notify_data *);
> +	int (*notify_recv_post_dequeue)(struct vsock_sock *, size_t,
> +		ssize_t, bool, struct vsock_transport_recv_notify_data *);
> +	int (*notify_send_init)(struct vsock_sock *,
> +		struct vsock_transport_send_notify_data *);
> +	int (*notify_send_pre_block)(struct vsock_sock *,
> +		struct vsock_transport_send_notify_data *);
> +	int (*notify_send_pre_enqueue)(struct vsock_sock *,
> +		struct vsock_transport_send_notify_data *);
> +	int (*notify_send_post_enqueue)(struct vsock_sock *, ssize_t,
> +		struct vsock_transport_send_notify_data *);
> +
> +	/* Shutdown. */
> +	int (*shutdown)(struct vsock_sock *, int);
> +
> +	/* Buffer sizes. */
> +	void (*set_buffer_size)(struct vsock_sock *, u64);
> +	void (*set_min_buffer_size)(struct vsock_sock *, u64);
> +	void (*set_max_buffer_size)(struct vsock_sock *, u64);
> +	u64 (*get_buffer_size)(struct vsock_sock *);
> +	u64 (*get_min_buffer_size)(struct vsock_sock *);
> +	u64 (*get_max_buffer_size)(struct vsock_sock *);
> +
> +	/* Addressing. */
> +	u32 (*get_local_cid)(void);
> +};
> +

Whoa.  This has grown *alot*.  Care to explain this please?  Patch
creating a Documentation/virtual/vsock.txt would be cool.

*_enqueue + *_dequeue is sending/receiving data, ok.

stream_has_data + stream_has_space + stream_rcvhiwat look like they are
needed for buffer management.  Details please (especially for
stream_rcvhiwat).

What is stream_is_active?
What is *_allow?

What are all those notify_* calls?

Why do you need vsock_transport_{send,recv}_notify_data structs?
Can't this live in vsock_sock->trans?

thanks,
  Gerd
