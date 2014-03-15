Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaCOX2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 19:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbaCOX2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 19:28:50 -0400
Date: Sat, 15 Mar 2014 19:28:46 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>
Cc: Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: race in audit_log_untrusted_string for task_struct::comm
Message-ID: <20140315232846.GE27244@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm investigating a race in audit_log_untrusted_string() in the case of
task_struct::comm.

Originally from commit 0a4ff8c2 audit_log_task() currently hands
task_struct::comm directly to audit_log_untrusted_string() which can
race if another task/thread on another CPU modifies it between the time
strlen() is called on it and the time it is processed in
audit_log_n_untrustedstring().  I originally thought it was just a
matter of the value being truncated or mixed between old and new values,
but it appears it is worse than that in that it causes following labels
to be dropped.  If it just affected the value of comm that was printed,
I am guessing this wouldn't be a big deal since the user can modify this
value anyway and we never did trust it.  however, since it affects the
rest of the line, it has to be addressed.

In commit 219f0817 from 2005, Stephen Smalley used get_task_comm() to
get the value of comm to log to audit_log_untrusted_string() which calls
the task_lock.  This is quite safe, but incurs overhead that may not be
found acceptable by some.

Eric subsequently used memcpy() in c2a7780e in 2008 in another area of the
code that stores the value for later rather than use it immediately, so
the race issue was not present there, but there is still the danger of
incomplete or mixed text in that field.

Both are safe in terms of avoiding losing other fields.  One might have
half-inconsistent information in it, the other incurs locking costs.         

I'm inclined to go get_task_comm() in all 5 locations, but if we care
more about locking overhead, I'll switch to memcpy().

Steve, do we care about the integrity of the comm field?
Eric, is the overhead of task_lock unacceptable?

Linked in this thread (should I be able to convince git send-email to
work with me) please find the get_task_comm() patch and the alternate
memcpy() patch.


- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
