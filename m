Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3AOKhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:37:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416Ab3AOKhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:37:12 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V4 0/3] handle polling erros in vhost/vhost_net
Date: Tue, 15 Jan 2013 18:28:43 +0800
Message-Id: <1358245726-16250-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update version of last version to fix the handling of polling errors
in vhost/vhost_net.

Currently, vhost and vhost_net ignore polling errors which can lead kernel
crashing when it tries to remove itself from waitqueue after the polling
failure. Fix this by:

- examing the POLLERR when set backend and report erros to userspace
- let tun always add to waitqueue in .poll() after the queue is created even if
  it was detached.

Changes from V3:
- make a smaller patch that doesn't touch the whole polling state and only check
  the polliner errors in backend setting.
- add a patch that allows tuntap to do polling/reading/writing when detached
  which could simplify the work of its user.

Changes from v2:
- check poll->wqh instead of the wrong assumption about POLLERR and waitqueue
- drop the whole tx polling state check since it was replaced by the wqh
  checking
- drop the buggy tuntap patch

Changes from v1:
- restore the state before the ioctl when vhost_init_used() fails
- log the error when meet polling errors in the data path
- don't put into waitqueue when tun_chr_poll() return POLLERR

Jason Wang (3):
  vhost_net: correct error handling in vhost_net_set_backend()
  vhost_net: handle polling errors when setting backend
  tuntap: allow polling/writing/reading when detached

 drivers/net/tun.c     |   18 +++++++++++-------
 drivers/vhost/net.c   |   41 ++++++++++++++++++++++++++++-------------
 drivers/vhost/vhost.c |   18 +++++++++++++++---
 drivers/vhost/vhost.h |    2 +-
 4 files changed, 55 insertions(+), 24 deletions(-)

