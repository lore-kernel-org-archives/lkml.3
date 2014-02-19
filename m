Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaBSWbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:31:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaBSWbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:31:48 -0500
Date: Wed, 19 Feb 2014 17:31:35 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
Message-ID: <20140219223135.GB28876@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	David Rientjes <rientjes@google.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
References: <20140218220606.GA9712@redhat.com>
 <20140219134025.fcd70941e1ec98723a1bd230@linux-foundation.org>
 <20140219215505.GA28876@redhat.com>
 <20140219140021.f187b2cdc396dab44e680078@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219140021.f187b2cdc396dab44e680078@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 02:00:21PM -0800, Andrew Morton wrote:
 
 > > I toyed with the idea of changing task_struct.make_it_fail to unsigned too,
 > > but only realized I missed that after I'd sent out the diff.
 > 
 > If we're touching the task_struct we could make it a bool.
 > 
 > Or just a single bit(field).  task_struct already has a bunch of
 > bitfields in it (strangely, they aren't contiguous).

afaics, asides from brk_randomized, they're contiguous, and gcc dtrt..

        unsigned int               in_execve:1;          /*   768:31  4 */
        unsigned int               in_iowait:1;          /*   768:30  4 */
        unsigned int               no_new_privs:1;       /*   768:29  4 */
        unsigned int               sched_reset_on_fork:1; /*   768:28  4 */
        unsigned int               sched_contributes_to_load:1; /*   768:27  4 */

So we could move the COMPAT_BRK ifdef and save 4 bytes for all the people still using libc5.
(Or those who are for some reason averse to heap randomization).

It's not really worth doing unless you're moving a bunch of other stuff around
in task_struct though, because as it is now, that struct has a bunch of alignment padding
& holes, so you're not going to save anything.

The other tricky part with reorganizing that struct is that so much of it is configurable.

	Dave

