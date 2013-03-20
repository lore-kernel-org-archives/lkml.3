Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3CTUQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:16:06 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38953 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab3CTUP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:15:57 -0400
From: Rik van Riel <riel@surriel.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com
Subject: ipc,sem: sysv semaphore scalability
Date: Wed, 20 Mar 2013 15:55:30 -0400
Message-Id: <1363809337-29718-1-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include lkml in the CC: this time... *sigh*
---8<---

This series makes the sysv semaphore code more scalable,
by reducing the time the semaphore lock is held, and making
the locking more scalable for semaphore arrays with multiple
semaphores.

The first four patches were written by Davidlohr Buesso, and
reduce the hold time of the semaphore lock.

The last three patches change the sysv semaphore code locking
to be more fine grained, providing a performance boost when
multiple semaphores in a semaphore array are being manipulated
simultaneously.

On a 24 CPU system, performance numbers with the semop-multi
test with N threads and N semaphores, look like this:

	vanilla		Davidlohr's	Davidlohr's +	Davidlohr's +
threads			patches		rwlock patches	v3 patches
10	610652		726325		1783589		2142206
20	341570		365699		1520453		1977878
30	288102		307037		1498167		2037995
40	290714		305955		1612665		2256484
50	288620		312890		1733453		2650292
60	289987		306043		1649360		2388008
70	291298		306347		1723167		2717486
80	290948		305662		1729545		2763582
90	290996		306680		1736021		2757524
100	292243		306700		1773700		3059159

