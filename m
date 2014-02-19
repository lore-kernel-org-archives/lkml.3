Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaBSSJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaBSSJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:12 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 0/5] audit: add restricted capability read-only netlink multicast socket
Date: Wed, 19 Feb 2014 13:08:18 -0500
Message-Id: <cover.1392831003.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This patch set adds a restricted capability read-only netlink multicast socket
to kaudit to enable userspace clients such as systemd to consume audit logs, in
addition to the existing bidirectional auditd userspace client. 
    
Currently, auditd has the CAP_AUDIT_CONTROL and CAP_AUDIT_WRITE capabilities
(both use CAP_NET_ADMIN).  The CAP_AUDIT_READ capability will be added for use
by read-only AUDIT_NLGRP_READLOG multicast group clients to the kaudit
subsystem.
  
This is accomplished by modifying the optional netlink per-protocol bind
function to return an error code.

https://bugzilla.redhat.com/show_bug.cgi?id=887992 

It needs a bit of massage to get past checkpatch.pl...

First posted:	https://www.redhat.com/archives/linux-audit/2013-January/msg00008.html
		https://lkml.org/lkml/2013/1/27/279

Richard Guy Briggs (5):
  audit: move kaudit thread start from auditd registration to kaudit
    init
  netlink: have netlink per-protocol bind function return an error
    code.
  audit: add netlink audit protocol bind to check capabilities on
    multicast join
  audit: add netlink multicast group for log read
  audit: send multicast messages only if there are listeners

 include/linux/netlink.h             |    2 +-
 include/uapi/linux/audit.h          |    8 ++++
 include/uapi/linux/capability.h     |    7 +++-
 kernel/audit.c                      |   66 +++++++++++++++++++++++++++++-----
 net/netfilter/nfnetlink.c           |    6 ++-
 net/netlink/af_netlink.c            |   30 +++++++++-------
 net/netlink/af_netlink.h            |    4 +-
 security/selinux/include/classmap.h |    2 +-
 8 files changed, 95 insertions(+), 30 deletions(-)

