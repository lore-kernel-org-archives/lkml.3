Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab3B1VP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:15:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab3B1VPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:15:24 -0500
Message-ID: <512FC89B.6030507@redhat.com>
Date: Thu, 28 Feb 2013 16:14:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com> <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com> <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com> <512E376D.70105@redhat.com> <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com> <512E6443.9050603@redhat.com> <CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com> <512E80E3.7060800@redhat.com> <CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com> <512EC7F0.60103@redhat.com> <1362024397.1867.28.camel@buesod1.americas.hpqcorp.net> <CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com> <512F7429.4020103@redhat.com> <CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com> <CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
In-Reply-To: <CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050901090803080504040600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050901090803080504040600
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/28/2013 03:26 PM, Linus Torvalds wrote:
> On Thu, Feb 28, 2013 at 10:22 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I'm sure there are other things we could do to improve ipc lock times
>> even if we don't actually split the lock, but the security one might
>> be a good first step.
>
> Btw, if somebody has a benchmark for threads using multiple ipc
> semaphores (from the same semget() allocation) concurrently, and we
> could have a simple way to see the contention without having to run
> some big DB thing, that would also be nice. Maybe there is something
> out there already? Google didn't find any, and the normal benchmarks
> I'm aware of all just do one single (private) ipc semaphore per
> process.
>
> Nothing gets some people going like just having a nice benchmark to
> show the effect.

I have modified one of the semop tests to use multiple semaphores.

To run the test, specify the number of threads.  If you want the
number of semaphores to be different from the number of threads,
specify a second commandline argument.

$ ./semop-multi
usage: ./semop-multi <threads> [nsems]


--------------050901090803080504040600
Content-Type: text/x-csrc;
 name="semop-multi.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="semop-multi.c"

#define _GNU_SOURCE
#include <sched.h>
#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <malloc.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/sem.h>

#define TEST_TIME	30
#define SEMMNI		128

int		semid;
int		state = 1;
unsigned long	*results_array;
int		threads_starting;
pthread_cond_t	thread_parent;
pthread_cond_t	thread_worker;
pthread_mutex_t	thread_lock;
int		nsems;

union semun {
	int val;
	struct semid_ds *buf;
	unsigned short int *array;
	struct seminfo *__buf;
	void *__pad;
};

void *
worker(void *arg)
{
	unsigned long	count = 0;
	int		id = (int)(unsigned long)arg;
	struct sembuf	sembuff;

	sembuff.sem_num = 0;
	sembuff.sem_flg = 0;

	pthread_mutex_lock(&thread_lock);
	threads_starting--;
	if (!threads_starting)
		pthread_cond_signal(&thread_parent);
	pthread_cond_wait(&thread_worker, &thread_lock);
	pthread_mutex_unlock(&thread_lock);

	for (;state;) {

		/* Move "id" ahead through the semaphores */
		sembuff.sem_num = (sembuff.sem_num + id) % nsems;

		/* Lock the semaphore */
		sembuff.sem_op = 1;
		if (semop(semid, &sembuff, 1) < 0) {
			perror("semop");
			exit(1);
		}

		/* Unlock the semaphore */
		sembuff.sem_op = -1;
		if (semop(semid, &sembuff, 1) < 0) {
			perror("semop");
			exit(1);
		}

		count += 2;
	}

	results_array[id] = count;

	return NULL;
}

int
main(int argc, char **argv)
{
	pthread_t	*thread_array;
	pthread_attr_t	thread_attr;
	int		thread_count;
	unsigned short	seminit[SEMMNI];
	union semun	sem_un;
	cpu_set_t	cpu;
	unsigned long	total = 0;
	int		i, ret;
	long		cpus;

	cpus = sysconf(_SC_NPROCESSORS_ONLN);

	if (argc < 2) {
		printf("usage: %s <threads> [nsems]\n", argv[0]);
		exit(1);
	}

	thread_count = atoi(argv[1]);

	if (thread_count < 0) {
		printf("threads must be >= 0\n");
		exit(1);
	}

	if (thread_count == 0)
		thread_count = cpus;

	if (argc > 2)
		nsems = atoi(argv[2]);
	else
		nsems = thread_count;
	if (nsems > SEMMNI)
		nsems = SEMMNI;

	printf("cpus %ld, threads: %d, semaphores: %d, test duration: %d secs\n", cpus, thread_count, nsems, TEST_TIME);

	thread_array = malloc(thread_count * sizeof(pthread_t));

	if (!thread_array) {
		perror("malloc(thread_array)");
		exit(1);
	}

	results_array = malloc(thread_count * sizeof(unsigned long));

	if (!results_array) {
		perror("malloc(results_array)");
		exit(1);
	}

	semid = semget(0x12345, nsems, 0777|IPC_CREAT );

	if (semid < 0) {
		perror("semget");
		exit(1);
	}

	for (i = 0; i < SEMMNI; i++)
		seminit[i] = 200;
	sem_un.array = seminit;
  
	if (semctl(semid, 1, SETALL, sem_un) < 0) {
		perror("semctl(setall)");
		exit(1);
	}

	pthread_mutex_init(&thread_lock, NULL);
	pthread_cond_init(&thread_parent, NULL);
	pthread_cond_init(&thread_worker, NULL);
	pthread_attr_init(&thread_attr);

	threads_starting = thread_count;

	for (i = 0; i < thread_count; i++) {

		CPU_ZERO(&cpu);
		CPU_SET(i % cpus, &cpu);

		ret = pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t), &cpu);

		if (ret) {
			printf("pthread_attr_setaffinity_np: %s\n", strerror(ret));
			exit(1);
		}

		ret = pthread_create(&thread_array[i], &thread_attr, worker, (void *)(unsigned long)i);

		if (ret) {
			printf("pthread_create: %s\n", strerror(ret));
			exit(1);
		}
	}

	pthread_attr_destroy(&thread_attr);

	pthread_mutex_lock(&thread_lock);
	while (threads_starting)
		pthread_cond_wait(&thread_parent, &thread_lock);
	pthread_cond_broadcast(&thread_worker);
	pthread_mutex_unlock(&thread_lock);

	sleep(TEST_TIME);
	state = 0;

	for (i = 0; i < thread_count; i++)
		pthread_join(thread_array[i], NULL);

	pthread_cond_destroy(&thread_parent);
	pthread_cond_destroy(&thread_worker);
	pthread_mutex_destroy(&thread_lock);

	if (semctl(semid, 1, IPC_RMID) < 0)
		perror("semctl(rmid)");

	for (i = 0; i < thread_count; i++)
		total += results_array[i];

	printf("total operations: %ld, ops/sec %ld\n", total, total / TEST_TIME);

	free(thread_array);
	free(results_array);

	return 0;
}

--------------050901090803080504040600--
