Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab3JPWCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:02:36 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50188 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760759Ab3JPWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:02:31 -0400
From: Jim Lieb <jlieb@panasas.com>
To: tytso@mit.edu, viro@zeniv.linux.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
Subject: [RFC PATCH 0/3] System call to switch user credentials
Date: Wed, 16 Oct 2013 15:01:56 -0700
Message-Id: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This system call implementation is the result of discussions at LSF
this last Feb about providing better kernel support to user mode file
servers.

Our use case is an NFS+pNFS+9P file server in user space.  We have to
switch user credentials for a number of operations such as CREATE,
MKDIR, and WRITE.  We currently use setfsuid(), setfsgid(), and setgroups()
for each of these calls followed by the same set of syscalls to revert
to root privileges.  We also must do a setcap to disable root privs so that
quotas and access checks work properly.  This results in a minimum of
7 system calls for each affected filesystem operation.  Each syscall
in this set creates a new creds object with its associated RCU resources.

Knfsd calls nfsd_setuser() to do the same thing in one call.

This system call does the same function as nfsd_setuser() but for user space.
It replaces the six system calls with just two and uses RCU more efficiently
by only doing it once.  This is done using the following struct which
combines all of the arguments that are passed but the corrent syscalls
and passes them to the system call.

	struct user_creds {
		uid_t		uid;
		gid_t		gid;
		unsigned	ngroups;
		gid_t		altgroups[0];
	};

Inside our server, we have implemented two functions to manage credentials
using a local user identity cache that has the following structure.
The req_ctx contains two members of interest, a pointer to the credentials
that are constructed by the server from the protocol and a file descriptor
which is described below.  The rest of the structure is housekeeping for
the user identity cache.

	struct req_ctx {
		/* other stuff like avl tree links */
		struct user_creds *creds;
		int creds_fd;
	};

The typical sequence for a protocol operation that creates or morphs
an object in the filesystem is:

	ctx = get_ctx(me->uid);
	become_client(ctx);
	/* mkdir, mknod, write as client user */
	restore_creds();

I have left out error handling to simplify the flow.  This replaces the
current setfsuid();setfsgid();setgroups(); before and after. get_ctx()
does a lookup in the cache.

The become_client function uses two forms of the system call.  We will
take the second first.  The SWCREDS_FSIDS command creates a new creds
for the task and fills it from the user_creds argument.  It also clears
the set of root capabilities in the effective capabilities.  This is
functionally equivalent to what nfsd_setuser() does for knfsd.

We currently set the reduced capabilities globally in order to keep the
overhead down.  This system call does this per call, leaving the rest
of the server with full capabilities.

This version of the system call opens an anonymous file and returns
an fd for it.  This fd is useless for I/O but it does allow
us to cache creds cheaply.  We close the file when we purge the cache
entry.

The first form uses the SWCREDS_FROMFD command and the appropriate fd
that was returned for this client user earlier.  The creds referenced
by the fd are used to override_creds the task's effective creds.  Actually,
any open file will do but the opened anonymous file is the least
overhead because all it consumes is a filp and fd slot.  The override_creds
does not consume any RCU resources so it is much faster and consumes
fewer resources.

int become_client(struct req_ctx *ctx)
{
	int ret;

	if (ctx->creds_fd >= 0) {
		ret = switch_creds(SWCREDS_FROMFD, ctx->creds_fd);
		if (ret < 0) {
			perror("become_client failed!");
			return ret;
		}
	} else {
		ret = switch_creds(SWCREDS_FSIDS, (unsigned long)ctx->creds);
		if (ret < 0) {
			perror("become_client with creds failed!");
			return ret;
		} else {
			fprintf(stderr, "New client: uid= %d, fd = %d\n",
			       ctx->creds->uid, ret);
			ctx->creds_fd = ret;
		}
	}
	return 0;
}

The restore_creds function simply uses the SWCREDS_REVERT command which
restores the task's real creds.  This is the safest route in our code
but one could also switch directly to another set safely.

int restore_creds(void)
{
	int ret;

	ret = switch_creds(SWCREDS_REVERT, 0);
	if (ret < 0) {
		perror("switch_creds back failed!\n");
		return ret;
	}
	return 0;
}

The first patch implements the system call itself.  The second two add
the syscall linkage for X86 and X86_64.  I chose the next available
numbers for those architectures as of 3.12-RC5. I added these patches as a
temporary bridge until official numbers are assigned.  I have also not
added entries for other architectures but there is nothing architecturally
dependent in this syscall so when appropriate, numbers can be assigned.

Please review and comment to me.  The code fragments above are from my
test program.

Regards,

Jim Lieb
NFS Ganesha project
