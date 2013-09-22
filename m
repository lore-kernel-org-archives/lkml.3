Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3IVCMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 22:12:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42922 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3IVCMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 22:12:03 -0400
From: Jia He <jiakernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jia He <jiakernel@gmail.com>
Subject: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in semaphore initialization
Date: Sun, 22 Sep 2013 10:11:24 +0800
Message-Id: <1379815884-11035-1-git-send-email-jiakernel@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
was removed because he wanted to move setting sem->sem_otime to one
place. But after that, the initial semop() will not set the otime
because its sem_op value is 0(in semtimedop,will not change
otime if alter == 1).

the error case:
process_a(server)       process_b(client)
semget()
semctl(SETVAL)
semop()
                        semget()
                        setctl(IP_STAT)
                        for(;;) {               <--not successful here
                          check until sem_otime > 0
                        }

provide test codes here:
$cat server.c

int semid;
int main()
{
	int key;
	struct semid64_ds sem_info;
	union semun arg;
	struct sembuf sop;

	key = ftok(SEM_PATH,'a');
	semid = semget(key,1,IPC_CREAT|IPC_EXCL|00666);
	if(semid < 0)
		perror("server:semget");

	arg.val = 0;
	if(semctl(semid,0,SETVAL,arg) == -1)
	        perror("semctl setval error");

	sop.sem_num = 0;
	sop.sem_op = 0;
	sop.sem_flg = 0;
	if (semop(semid, &sop, 1) == -1)
		perror("semop error");

	sleep(30);

	if(semctl(semid, 0, IPC_RMID) == -1)
		perror("semctl IPC_RMID");
	else printf("remove sem ok\n");
}

$cat client.c
int semid;
int main()
{
	int i;
	int key;
	union semun arg;
	struct semid64_ds sem_info;

	key = ftok(SEM_PATH,'a');
	semid = semget(key,1,IPC_CREAT|00666);
	if(semid < 0)
		perror("client:semget");
	for (i = 0; i < MAX_TRIES; i++)
	{
		arg.buf = &sem_info;
		semctl(semid, 0, IPC_STAT, arg);
		if (sem_info.sem_otime != 0) break;
		sleep(1);
	}

	if(MAX_TRIES == i)
		printf("error in opening a existed sem\n");
	else
		printf("open exsited sem sucessfully\n");
	return 0;
}

the steps to test:
touch /tmp/my_sem
./server &
sleep 1
./client &

With the patch
1.test output:
error in opening a existed sem
2.cat /proc/sysvipc/sem
the field sem_otime is always zero

Without this patch
1.test output:
open exsited sem sucessfully
2.cat /proc/sysvipc/sem
the field sem_otime is not zero

Signed-off-by: Jia He <jiakernel@gmail.com>
---
 ipc/sem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 69b6a21..8e01e76 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -590,6 +590,7 @@ static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 		sop--;
 	}
 	
+	sma->sem_base[sops[0].sem_num].sem_otime = get_seconds();
 	return 0;
 
 out_of_range:
-- 
1.8.1.2

