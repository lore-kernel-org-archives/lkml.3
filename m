Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3FMWKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:10:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab3FMWKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:10:42 -0400
Date: Thu, 13 Jun 2013 15:10:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130613151040.8e11da022519fff7d5e8ea77@linux-foundation.org>
In-Reply-To: <20130613193514.GD13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613020536.GA10979@localhost>
	<20130612200311.7f9d938a.akpm@linux-foundation.org>
	<20130613185318.GB12075@mtj.dyndns.org>
	<20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
	<20130613191507.GB13970@mtj.dyndns.org>
	<20130613122339.239a721d097a64435817a780@linux-foundation.org>
	<20130613193514.GD13970@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 12:35:14 -0700 Tejun Heo <tj@kernel.org> wrote:

> > > Maybe we can layer things so that we have percpu layer on top of
> > > id[r|a] and, say, mapping id to point is still done by idr, or the
> > > percpu tag allocator uses ida for tag chunk allocations, but it's
> > > still gonna be something extra on top.
> > 
> > It's not obvious that explicit per-cpu is needed.  Get an ID from
> > ida_get_new_above(), multiply it by 16 and store that in device-local
> > storage, along with a 16-bit bitmap.  Blam, 30 lines of code and the
> > ida_get_new_above() cost is reduced 16x and it's off the map.
> 
> I'm fairly sure it'd have to be per-cpu.  The idr allocation is
> reduced 16x but now each of those 16 slots needs to be allocated.  The
> problem hasn't gone away and we do need some sort of utility to help
> that as drivers tend to resort to things like linear bitmap scan
> combined with test_and_set_bit() making one cacheline extremely hot.

Well OK, make it per-cpu then.  Or think up something better.

Look, we're falling into the age-old trap of trying to justify existing
code just because it exists.

Stop.  Take a step back and pretend that the percpu tag allocator patch
never existed.  Now, define the problem and propose solutions.

The absolute dead last and worst solution is "implement something new
which largely duplicates existing code".  Such a step requires an
extraordinary amount of justification and that hasn't happened.
