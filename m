Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaJXQRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:17:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:51153 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaJXQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:17:33 -0400
Message-ID: <544A7B9B.2030508@windriver.com>
Date: Fri, 24 Oct 2014 10:17:31 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: semantics of reader/writer semaphores in rt patch?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.118.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently noticed that when CONFIG_PREEMPT_RT_FULL is enabled the 
semantics change. From "include/linux/rwsem_rt.h":

  * Note that the semantics are different from the usual
  * Linux rw-sems, in PREEMPT_RT mode we do not allow
  * multiple readers to hold the lock at once, we only allow
  * a read-lock owner to read-lock recursively. This is
  * better for latency, makes the implementation inherently
  * fair and makes it simpler as well.

How is this valid? It seems to me that the mainline kernel could have 
code paths that depend on having multiple threads of execution be able 
to hold the reader lock simultaneously. For example:


thread A:
take rw_semaphore X for reading
take lock Y, modify data, release lock Y
wake up thread B
wait on conditional protected by lock Y
free rw_semaphore X

thread B:
take rw_semaphore X for reading
wait on conditional protected by lock Y
send message to wake up thread A
free rw_semaphore X


In the regular kernel this would work, in the RT kernel it would deadlock.

Does the RT kernel just disallow this sort of algorithm?

Thanks,
Chris
