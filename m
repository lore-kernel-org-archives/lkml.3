Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaHXDjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 23:39:45 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:65067 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaHXDjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 23:39:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: akpm@linux-foundation.org, davidlohr@hp.com, linux-kernel@vger.kernel.org,
        manfred@colorfullife.com, bfields@redhat.com, dledford@redhat.com
Message-id: <fb54ebb04006.53f95e80@langara.bc.ca>
Date: Sun, 24 Aug 2014 03:39:44 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: [PATCH] V1 2/2] ipc: let message queues use SIGEV_THREAD_ID with
 mq_notify
X-Accept-Language: en
In-reply-to: <fc15e6ee2a3f.53f95da3@langara.bc.ca>
References: <fb54e896348f.53f95d2f@langara.bc.ca>
 <fc15e6ee2a3f.53f95da3@langara.bc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any one who wants a quick way to test the changes can use the
following hacky program that works as an init program.

Thank you,
Steven Stewart-Gallus

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <mqueue.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/reboot.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>

/* GLibc does not expose sigev_notify_thread_id so we hack it in manually */

#ifndef __ARCH_SIGEV_PREAMBLE_SIZE
#define __ARCH_SIGEV_PREAMBLE_SIZE (sizeof(int) * 2 + sizeof(sigval_t))
#endif

#define SIGEV_MAX_SIZE	64
#define SIGEV_PAD_SIZE	((SIGEV_MAX_SIZE - __ARCH_SIGEV_PREAMBLE_SIZE)	\
			 / sizeof(int))

struct my_sigevent {
	sigval_t sigev_value;
	int sigev_signo;
	int sigev_notify;
	union {
		int _pad[SIGEV_PAD_SIZE];
		int _tid;

		struct {
			void (*_function)(sigval_t);
			void *_attribute;	/* really pthread_attr_t */
		} _sigev_thread;
	} _sigev_un;
};

#define sigev_notify_function	_sigev_un._sigev_thread._function
#define sigev_notify_attributes	_sigev_un._sigev_thread._attribute
#define sigev_notify_thread_id	 _sigev_un._tid



struct message {
	int number;
};

static mqd_t mq;

static pid_t gettid(void)
{
	return syscall(__NR_gettid);
}

static void * start_routine(void * arg)
{
	{
		struct message message = {
			.number = 4
		};
		if (-1 == mq_send(mq, (char*)&message, sizeof message, 0)) {
			perror("mq_send");
			_Exit(EXIT_FAILURE);
		}
	}

	{
		struct message message = {
			.number = 5
		};
		if (-1 == mq_send(mq, (char*)&message, sizeof message, 0)) {
			perror("mq_send");
			_Exit(EXIT_FAILURE);
		}
	}

	{
		struct message message = {
			.number = 0
		};
		if (-1 == mq_send(mq, (char*)&message, sizeof message, 0)) {
			perror("mq_send");
			_Exit(EXIT_FAILURE);
		}
	}

	return NULL;
}

int main(int argc, char *argv[])
{
	int errnum;

	/* Fork to allow signals to be received */
	{
		pid_t child = fork();
		if (-1 == child) {
			perror("fork");
			return EXIT_FAILURE;
		}

		if (child != 0) {
			siginfo_t info;
			do {
				errnum = -1 == waitid(P_PID, child, &info, WEXITED) ? errno : 0;
			} while (EINTR == errnum);
			if (errnum != 0) {
				assert(errnum != EINVAL);
				assert(errnum != ECHILD);
				assert(false);
			}
			reboot(RB_POWER_OFF);
		}
	}

	{
		struct mq_attr attr = { 0 };
		attr.mq_maxmsg = 8U;
		attr.mq_msgsize = sizeof (struct message);
		mq = mq_open("/foo", O_RDWR | O_CREAT | O_EXCL | O_NONBLOCK, 0, &attr);
	}
	if (-1 == mq) {
		perror("mq_open");
		return EXIT_FAILURE;
	}


	sigset_t rtset;
	sigemptyset(&rtset);
	sigaddset(&rtset, SIGRTMIN);
	pthread_sigmask(SIG_BLOCK, &rtset, NULL);

	pthread_t worker;
	if ((errnum = pthread_create(&worker, NULL, start_routine, NULL)) != 0) {
		errno = errnum;
		perror("pthread_create");
		return EXIT_FAILURE;
	}

	for (;;) {
		{
			struct my_sigevent sev = { 0 };

			sev.sigev_notify = SIGEV_THREAD_ID;
			sev.sigev_signo = SIGRTMIN;

			sev.sigev_notify_thread_id = gettid();

			if (-1 == mq_notify(mq,(struct sigevent*) &sev)) {
				perror("mq_notify");
				return EXIT_FAILURE;
			}
		}

		for (;;) {
			struct message message;
			if (-1 == mq_receive(mq, (char*)&message, sizeof message, 0)) {
				errnum = errno;
			} else {
				errnum = 0;
			}

			if (EAGAIN == errnum) {
				break;
			}

			if (errnum != 0) {
				errno = errnum;
				perror("mq_receive");
				return EXIT_FAILURE;
			}

			printf("received: %u\n", message.number);

			if (0 == message.number) {
				goto exit_loop;
			}
		}

		{
			int xx;
			if (-1 == sigwait(&rtset, &xx)) {
				perror("sigwait");
				return EXIT_FAILURE;
			}
		}

		/* Flush pending signals */
		pthread_sigmask(SIG_UNBLOCK, &rtset, NULL);
		pthread_sigmask(SIG_BLOCK, &rtset, NULL);
	}
exit_loop:
	return EXIT_SUCCESS;
}

