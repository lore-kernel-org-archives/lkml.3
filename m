Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3ESXRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 19:17:30 -0400
Received: from MAIL1.WPI.EDU ([130.215.36.91]:46605 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab3ESXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 19:17:29 -0400
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 May 2013 19:17:29 EDT
From: Neal Murphy <neal.p.murphy@alum.wpi.edu>
Reply-To: neal.p.murphy@alum.wpi.edu
Organization: Self
To: linux-kernel@vger.kernel.org
Subject: pipe/fifo, set exception for select() when read end is not open
Date: Sun, 19 May 2013 18:54:29 -0400
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305191854.29462.neal.p.murphy@alum.wpi.edu>
X-PerlMx-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1900_1999 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, NO_URI_FOUND 0, RDNS_BROADBAND 0, RDNS_GENERIC_POOLED 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RDNS_SUSP_SPECIFIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __RDNS_BROADBAND_5 0, __RDNS_POOLED_11 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been looking at the gule hacks I have to use to get inotifywait to work 
in shell scripts. So I figgered I would hack inotifywait to look at exceptions 
in its select() loop. No joy.

inotifywait loops using select() to look for changes to at least one inotify 
FD. Whenever it sees a change, it reads the event and sends it to stdout. 
Cool. This works well and uses little CPU time. But there's a problem.

Suppose you have inotifywait monitoring a specific file for a change, such as 
"wait for this file to be deleted." And you have piped inotifywait to "while 
read a b c". The problem is that when the 'while' loop gets the DELETE event, 
it does what is needed and exits. And it is expected that inotifywait will 
exit.

But because the file it was watching has been deleted and can cause no more 
events, inotifywait will never receive another event, never return from 
select(), never write to the pipe, and never know that the pipe's reader 
exitted. It will never know that it should exit. Then I got to wondering why 
it is that writing to a pipe is the *only* way to know that the reader end is 
or has been closed (other than via complicated signalling). And wondering why.

Would it be possible to set an exception on a pipe's or fifo's writer FD when 
the reader FD is not open (when there are no readers or when there are none 
left)? Would it be reasonable to do this? I imagine a pipe should have a 'last 
reader closed' exception, while fifos could benefit from that and/or a 'no 
readers' exception.

If this exception existed, inotifywait could watch for read and exception 
changes using select(). An exception on stdout would almost certainly mean 
that the pipe has been welded shut, so inotifywait should just exit. This 
can't be the only example of a program that could benefit from knowing that 
one of its output pipes is closed without needing to write to the pipe to find 
out.

Thanks,
N

(Please CC me on replies.)
