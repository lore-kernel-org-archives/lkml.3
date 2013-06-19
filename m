Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3FSFvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:51:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab3FSFva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:51:30 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, edumazet@google.com, hkchu@google.com, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next rfc 0/3] increase the limit of tuntap queues
Date: Wed, 19 Jun 2013 13:40:49 +0800
Message-Id: <1371620452-49349-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series tries to increase the limit of tuntap queues. Histrocially there're
two reasons which prevent us from doing this:

- We store the hash buckets in tun_struct which results a very large size of
  tun_struct, this high order memory allocation fail easily when the memory were
  fragmented.
- The netdev_queue and netdev_rx_queue array in netdevice were allocated through
  kmalloc, which may cause a high order memory allocation too when we have
  several queues. E.g. sizeof(netdev_queue) is 320, which means a high order
  allocation will happens when the device has more than 12 queues.

So this series tries to address those issues by switching to use flex array. All
entries were preallocated, and since flex array always do a order-0 allocation,
we can safely increase the limit after.

Only compile test, comments or review are more than welcomed.

Jason Wang (3):
  net: avoid high order memory allocation for queues by using flex
    array
  tuntap: reduce the size of tun_struct by using flex array
  tuntap: increase the max queues to 16

 drivers/net/tun.c         |   59 ++++++++++++++++++++++++++++++++------------
 include/linux/netdevice.h |   13 ++++++----
 net/core/dev.c            |   57 +++++++++++++++++++++++++++++++------------
 net/core/net-sysfs.c      |   15 +++++++----
 net/openvswitch/flow.c    |    2 +-
 5 files changed, 102 insertions(+), 44 deletions(-)

