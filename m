Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaILWSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:18:55 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:43425
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaILWSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:18:53 -0400
Date: Sat, 13 Sep 2014 00:18:52 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 0/3] ns, procfs: pid conversion between ns and
 showing pidns hierarchy
Message-ID: <20140912221852.GA18234@mail.hallyn.com>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so the below is just 30 mins worth of playing around, will hang if you give
it bad pids, and requires privilege, but shows how to get pid conversion
in some cases.  Basically it gives you what I had previously suggested
for the query_pid syscall before.

In general, usage is

translatepid reporter_pid dest_pid query_pid

where reporter_pid and dest_pid are pids in your pidns.  It will assume
query_pid is a valid pid in reporter_pid's pidns, and return the pid of
the same process in dest_pid's namespace.

In particular,

if a process in a container (say pid 1, pid 24444 in the host pidns)
reports something about another process (say pid 262) in the container,
and you have a shell (pid 1092) on the host, you can figure out the pid
for 262 in your host pidns using

translatepid $$ 24444 262

or to figure out what pid 25152 on the host is knows as in the
container,

translatepid 24444 $$ 25152

I wonder whether this is enough to give you all you need.  While it
won't be super-fast, you could use and ppid info to figure out who
is pid 1, etc.

#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <sys/un.h>
#include <sched.h>
#include <errno.h>

/*
 * general usage:
 *    translatepid reporter_ns_pid dest_ns_pid query_pid
 *
 * reporter_ns_pid and dest_ns_pid are pids in your namespace.
 * query_pid is in reporter_ns_pid's namespace.  The result is
 * in dest_ns_pid's namespace.
 *
 * If you see pid 10064 and want to know what it's vpid
 * is:
 *    translatepid $$ 10064 10064
 * If pid 10064 reported something about a pid 9 in its
 * own ns and you want to know what pid that is in your
 * ns:
 *    translatepid 10064 $$ 9
 *
 * First cpid1, in rpid's pidns, sends us query_pid.
 * Then we send that translated pid to cpid2, in dpid's pidns.
 * It prints out the answer
 */

static int proxyrecv(int sockfd, void *buf, size_t len)
{
	struct timeval tv;
	fd_set rfds;

	FD_ZERO(&rfds);
	FD_SET(sockfd, &rfds);
	tv.tv_sec = 2;
	tv.tv_usec = 0;

	if (select(sockfd+1, &rfds, NULL, NULL, &tv) < 0)
		return -1;
	return recv(sockfd, buf, len, MSG_DONTWAIT);
}

void send_creds(int sock, struct ucred *cred)
{
	struct msghdr msg = { 0 };
	struct iovec iov;
	struct cmsghdr *cmsg;
	char cmsgbuf[CMSG_SPACE(sizeof(*cred))];
	char buf[1];
	buf[0] = 'p';

	if (proxyrecv(sock, buf, 1) != 1) {
		printf("%s: Error getting reply from server over socketpair",
			  __func__);
		exit(1);
	}

	msg.msg_control = cmsgbuf;
	msg.msg_controllen = sizeof(cmsgbuf);

	cmsg = CMSG_FIRSTHDR(&msg);
	cmsg->cmsg_len = CMSG_LEN(sizeof(struct ucred));
	cmsg->cmsg_level = SOL_SOCKET;
	cmsg->cmsg_type = SCM_CREDENTIALS;
	memcpy(CMSG_DATA(cmsg), cred, sizeof(*cred));

	msg.msg_name = NULL;
	msg.msg_namelen = 0;

	iov.iov_base = buf;
	iov.iov_len = sizeof(buf);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;

	if (sendmsg(sock, &msg, 0) < 0) {
		printf("%s: failed at sendmsg: %s", __func__,
			  strerror(errno));
		exit(1);
	}
}

void recv_creds(int sock, struct ucred *cred)
{
	struct msghdr msg = { 0 };
	struct iovec iov;
	struct cmsghdr *cmsg;
	char cmsgbuf[CMSG_SPACE(sizeof(*cred))];
	char buf[1];
	int ret;
	int optval = 1;

	cred->pid = -1;
	cred->uid = -1;
	cred->gid = -1;

	if (setsockopt(sock, SOL_SOCKET, SO_PASSCRED, &optval, sizeof(optval)) == -1) {
		printf("Failed to set passcred: %s", strerror(errno));
		return;
	}
	buf[0] = '1';
	if (write(sock, buf, 1) != 1) {
		printf("Failed to start write on scm fd: %s", strerror(errno));
		return;
	}

	msg.msg_name = NULL;
	msg.msg_namelen = 0;
	msg.msg_control = cmsgbuf;
	msg.msg_controllen = sizeof(cmsgbuf);

	iov.iov_base = buf;
	iov.iov_len = sizeof(buf);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;

	// retry logic is not ideal, especially as we are not
	// threaded.  Sleep at most 1 second waiting for the client
	// to send us the scm_cred
	ret = recvmsg(sock, &msg, 0);
	if (ret < 0) {
		printf("Failed to receive scm_cred: %s",
			  strerror(errno));
		return;
	}

	cmsg = CMSG_FIRSTHDR(&msg);

	if (cmsg && cmsg->cmsg_len == CMSG_LEN(sizeof(struct ucred)) &&
			cmsg->cmsg_level == SOL_SOCKET &&
			cmsg->cmsg_type == SCM_CREDENTIALS) {
		memcpy(cred, CMSG_DATA(cmsg), sizeof(*cred));
	}
}

int main(int argc, char *argv[])
{
	pid_t rpid, dpid, qpid;
	pid_t cpid1, cpid2;
	int optval = 1;
	struct ucred u;
	char path[100];
	int fd;

	int sv[2];

	if (argc != 4) {
		printf("Usage: %s report_pid dest_pid query_pid\n", argv[0]);
		exit(1);
	}

	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sv) < 0) {
		perror("socketpair");
		exit(1);
	}
	rpid = atoi(argv[1]);
	dpid = atoi(argv[2]);
	qpid = atoi(argv[3]);

	if ((cpid1 = fork()) < 0) {
		perror("fork");
		exit(1);
	}
	if (cpid1 == 0) {
		int xpid;
		sprintf(path, "/proc/%d/ns/pid", rpid);
		fd = open(path, O_RDWR);
		if (fd < 0) {
			perror("open of nspid");
			exit(1);
		}
		if (setns(fd, 0) < 0) {
			perror("setns");
			exit(1);
		}
		if ((xpid = fork()) < 0)
			exit(1);
		if (xpid == 0) {
			u.uid = 0;  u.gid = 0;  u.pid = qpid;
			send_creds(sv[0], &u);
		}
		exit(0);
	}
	recv_creds(sv[1], &u);

	close(sv[0]);
	close(sv[1]);

	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sv) < 0) {
		perror("socketpair");
		exit(1);
	}
	if ((cpid2 = fork()) < 0) {
		perror("fork");
		exit(1);
	}

	if (cpid2 == 0) {
		pid_t xpid;
		sprintf(path, "/proc/%d/ns/pid", dpid);
		fd = open(path, O_RDWR);
		if (fd < 0) {
			perror("open of nspid");
			exit(1);
		}
		if (setns(fd, 0) < 0) {
			perror("setns");
			exit(1);
		}
		if ((xpid = fork()) < 0)
			exit(1);
		if (xpid == 0) {
			recv_creds(sv[1], &u);
			printf("pid is: %d\n", (int) u.pid);
		}
		exit(0);
	}

	send_creds(sv[0], &u);

	waitpid(cpid2, NULL, 0);
	exit(0);
}
