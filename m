Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaCJPz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:55:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40649 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaCJPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:55:24 -0400
Date: Mon, 10 Mar 2014 15:55:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140310155520.GA8443@ZenIV.linux.org.uk>
References: <20140303232858.GO18016@ZenIV.linux.org.uk>
 <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
 <20140303234207.GQ18016@ZenIV.linux.org.uk>
 <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
 <20140304002342.GS18016@ZenIV.linux.org.uk>
 <CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
 <20140304010517.GT18016@ZenIV.linux.org.uk>
 <20140304200027.GA11932@ZenIV.linux.org.uk>
 <CA+55aFy2G5e0oBNWwmEiA5VS9+bB37JRNV2=X161FKEeH_odwA@mail.gmail.com>
 <20140305000411.GV18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20140305000411.GV18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2014 at 12:04:11AM +0000, Al Viro wrote:
> There's also a pile of crap around sockfd_lookup/sockfd_put, related
> to that.   Moreover, there's net/compat.c, which probably ought to
> have the compat syscalls themselves moved to net/socket.c (under
> ifdef CONFIG_COMPAT) and switched to sockfd_lookup_light().
> There's l2tp_tunnel_sock_lookup(), which is simply broken - it assumes
> that if tunnel->fd still resolves to a socket, that socket must
> be l2tp one.  Trivial to drive into BUG_ON(), in queue_work() callback,
> no less...  There's bluetooth, assuming that pretty much the same
> (that if it got a file descriptor that resolves to a socket, it must
> be a bluetooth one).  BTW, I wonder what will happen if one gives
> iscsi_sw_tcp_conn_bind() descriptor of a socket of sufficiently
> weird sort...
> 
> Then there's staging/usbip with its sockfd_to_socket(), which is more or
> less parallel to sockfd_lookup().  And open-coded analogs in nbd and
> ncpfs...

OK, I've gone through most of that; bluetooth is, indeed, oopsable (as simple
as e.g.
        int sv[2];
        int fd = socket(PF_BLUETOOTH, SOCK_RAW, BTPROTO_CMTP);
        struct cmtp_connadd_req r = {};
        socketpair(PF_LOCAL, SOCK_STREAM, 0, sv);
        r.sock = sv[0];
        ioctl(fd, CMTPCONNADD, (unsigned long)&r);
and similar with BNEP) and that one is easy to fix.  l2tp I'd rather leave
for net folks to deal with - the problem there is that we stash sock *and*
descriptor number into struct l2tp_tunnel in l2tp_tunnel_create() and expect
l2tp_tunnel_sock_lookup() to find that descriptor (tunnel->fd) resolving
to nothing (if it got already closed) or to the same socket.  Unfortunately,
the caller (l2tp_tunnel_del_work()) expects to find l2tp socket in the latter
case, so having it replaced with unrelated socket will do nasty things
to that caller.  It looks rather silly, actually - the actual fuckup happens
when l2tp_tunnel_del_work() passes what has come from socket->sk to
l2tp_tunnel_sock_put(), which does
        struct l2tp_tunnel *tunnel = l2tp_sock_to_tunnel(sk);
to find the tunnel its caller already had.  Looks too convoluted for its
own good, and my first inclination would be to collapse l2tp_tunnel_sock_*
into the (only) caller, but I'm not sure if I'm not missing some subtle
race prevention in those back-and-forth lookups.  In any case, it can
lead to l2tp_sock_to_tunnel() called on a sock that has nothing to do with
l2tp, so we do have a bug there.

I've attached bluetooth fixes; this stuff is obviously better off in one of
the net trees.  Not sure if it's worth Cc:stable - up to Marcel and Davem.
These bugs are oopsable, but you need CAP_NET_ADMIN to step into those...

I think that what's in vfs.git#for-linus right now is OK to pull; it survives
all the beating I could think of.  Linus, could you pull from the usual place?

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      ocfs2 syncs the wrong range...
      sockfd_lookup_light(): switch to fdget^W^Waway from fget_light
      get rid of fget_light()

Linus Torvalds (1):
      vfs: atomic f_pos accesses as per POSIX

Diffstat:
 fs/file.c            |   56 +++++++++++++++++++++++++++++++++++++++++++-------------
 fs/file_table.c      |    1 +
 fs/namei.c           |    2 +-
 fs/ocfs2/file.c      |    8 ++++----
 fs/open.c            |    4 ++++
 fs/read_write.c      |   40 ++++++++++++++++++++++++++--------------
 include/linux/file.h |   27 +++++++++++++++------------
 include/linux/fs.h   |    8 ++++++--
 net/socket.c         |   13 +++++++------
 9 files changed, 107 insertions(+), 52 deletions(-)


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-bluetooth-hidp_connection_add-unsafe-use-of-l2cap_pi.patch"

>From f49d9ab3220ece0b635b18212bfc44444e9b5f41 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 9 Mar 2014 13:11:59 -0400
Subject: [PATCH 1/3] bluetooth: hidp_connection_add() unsafe use of
 l2cap_pi()

it's OK after we'd verified the sockets, but not before that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/bluetooth/hidp/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index d9fb934..6134618 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1332,13 +1332,14 @@ int hidp_connection_add(struct hidp_connadd_req *req,
 {
 	struct hidp_session *session;
 	struct l2cap_conn *conn;
-	struct l2cap_chan *chan = l2cap_pi(ctrl_sock->sk)->chan;
+	struct l2cap_chan *chan;
 	int ret;
 
 	ret = hidp_verify_sockets(ctrl_sock, intr_sock);
 	if (ret)
 		return ret;
 
+	chan = l2cap_pi(ctrl_sock->sk)->chan;
 	conn = NULL;
 	l2cap_chan_lock(chan);
 	if (chan->conn) {
-- 
1.7.10.4


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-cmtp-cmtp_add_connection-should-verify-that-it-s-dea.patch"

>From 790f94a74f8214baab44eb346a346640e6335319 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 10 Mar 2014 10:50:10 -0400
Subject: [PATCH 2/3] cmtp: cmtp_add_connection() should verify that it's
 dealing with l2cap socket

... rather than relying on ciptool(8) never passing it anything else.  Give
it e.g. an AF_UNIX connected socket (from socketpair(2)) and it'll oops,
trying to evaluate &l2cap_pi(sock->sk)->chan->dst...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/bluetooth/cmtp/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 67fe5e8..fd57db8 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -333,6 +333,8 @@ int cmtp_add_connection(struct cmtp_connadd_req *req, struct socket *sock)
 	int i, err;
 
 	BT_DBG("");
+	if (!l2cap_is_socket(sock))
+		return -EBADFD;
 
 	session = kzalloc(sizeof(struct cmtp_session), GFP_KERNEL);
 	if (!session)
-- 
1.7.10.4


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-bnep-bnep_add_connection-should-verify-that-it-s-dea.patch"

>From 4d86300249b507f27e8c55c0d3bf1fa2653f9b17 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 10 Mar 2014 11:08:35 -0400
Subject: [PATCH 3/3] bnep: bnep_add_connection() should verify that it's
 dealing with l2cap socket

same story as cmtp

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/bluetooth/bnep/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index a841d3e..c7a19a1 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -533,6 +533,9 @@ int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
 
 	BT_DBG("");
 
+	if (!l2cap_is_socket(sock))
+		return -EBADFD;
+
 	baswap((void *) dst, &l2cap_pi(sock->sk)->chan->dst);
 	baswap((void *) src, &l2cap_pi(sock->sk)->chan->src);
 
-- 
1.7.10.4


--2fHTh5uZTiUOsy+g--
