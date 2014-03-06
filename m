Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCFMqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaCFMqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:46:47 -0500
Subject: [PATCH 0/8] AF_RXRPC fixes and development [ver #2]
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: dhowells@redhat.com, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 12:46:15 +0000
Message-ID: <20140306124614.16645.50744.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dave,

Here are some AF_RXRPC fixes (to tag rxrpc-20140226):

 (1) Fix to remove incorrect checksum calculation made during recvmsg().  It's
     unnecessary to try to do this there since we check the checksum before
     reading the RxRPC header from the packet.

 (2) Fix to prevent the sending of an ABORT packet in response to another
     ABORT packet and inducing a storm.

 (3) Fix UDP MTU calculation from parsing ICMP_FRAG_NEEDED packets where we
     don't handle the ICMP packet not specifying an MTU size.

And development patches (to tag rxrpc-devel-20140304):

 (4) Add sysctls for configuring RxRPC parameters, specifically various delays
     pertaining to ACK generation, the time before we resend a packet for
     which we don't receive an ACK, the maximum time a call is permitted to
     live and the amount of time transport, connection and dead call
     information is cached.

 (5) Improve ACK packet production by adjusting the handling of ACK_REQUESTED
     packets, ignoring the MORE_PACKETS flag, delaying the production of
     otherwise immediate ACK_IDLE packets and delaying all ACK_IDLE production
     (barring the call termination) to half a second.

 (6) Add more sysctl parameters to expose the Rx window size, the maximum
     packet size that we're willing to receive and the number of jumbo rxrpc
     packets we're willing to handle in a single UDP packet.

 (7) Request ACKs on alternate DATA packets so that the other side doesn't
     wait till we fill up the Tx window.

 (8) Use a RCU hash table to look up the rxrpc_call for an incoming packet
     rather than stepping through a hierarchy involving several spinlocks.

They can be found in this git branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc

David
---
David Howells (5):
      af_rxrpc: Fix UDP MTU calculation from ICMP_FRAG_NEEDED
      af_rxrpc: Add sysctls for configuring RxRPC parameters
      af_rxrpc: Improve ACK production
      af_rxrpc: Expose more RxRPC parameters via sysctls
      af_rxrpc: Request an ACK for every alternate DATA packet

Tim Smith (3):
      af_rxrpc: Remove incorrect checksum calculation from rxrpc_recvmsg()
      af_rxrpc: Prevent RxRPC peers from ABORT-storming one another
      af_rxrpc: Keep rxrpc_call pointers in a hashtable


 Documentation/networking/rxrpc.txt |   81 ++++++++++++++
 net/rxrpc/Makefile                 |    5 -
 net/rxrpc/af_rxrpc.c               |    9 ++
 net/rxrpc/ar-ack.c                 |   61 +++++++++-
 net/rxrpc/ar-call.c                |  213 +++++++++++++++++++++++++++++++++++-
 net/rxrpc/ar-connection.c          |   10 +-
 net/rxrpc/ar-error.c               |    1 
 net/rxrpc/ar-input.c               |  190 ++++++++++++++------------------
 net/rxrpc/ar-internal.h            |   40 ++++++-
 net/rxrpc/ar-output.c              |   15 ++-
 net/rxrpc/ar-recvmsg.c             |   25 ----
 net/rxrpc/ar-skbuff.c              |    7 +
 net/rxrpc/ar-transport.c           |   10 +-
 net/rxrpc/sysctl.c                 |  146 +++++++++++++++++++++++++
 14 files changed, 645 insertions(+), 168 deletions(-)
 create mode 100644 net/rxrpc/sysctl.c

