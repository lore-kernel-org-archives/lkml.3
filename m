Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbaGXUjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:39:48 -0400
Received: from plane.gmane.org ([80.91.229.3]:56753 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934581AbaGXUjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:39:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Reading large amounts from /dev/urandom broken
Date: Thu, 24 Jul 2014 13:39:25 -0700
Message-ID: <lqrqu0$5pv$1@ger.gmane.org>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com> <20140723151459.GA6673@thunk.org> <1406128778.26440.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 50.245.141.77
User-Agent: KNode/4.13.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Frederic Sowa wrote:

> On Mi, 2014-07-23 at 11:14 -0400, Theodore Ts'o wrote:
>> On Wed, Jul 23, 2014 at 04:52:21PM +0300, Andrey Utkin wrote:
>> > Dear developers, please check bugzilla ticket
>> > https://bugzilla.kernel.org/show_bug.cgi?id=80981 (not the initial
>> > issue, but starting with comment#3.
>> > 
>> > Reading from /dev/urandom gives EOF after 33554431 bytes.  I believe
>> > it is introduced by commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc,
>> > with the chunk
>> > 
>> > nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
>> > 
>> > which is described in commit message as "additional paranoia check to
>> > prevent overly large count values to be passed into urandom_read()".
>> > 
>> > I don't know why people pull such large amounts of data from urandom,
>> > but given today there are two bugreports regarding problems doing
>> > that, i consider that this is practiced.
>> 
>> I've inquired on the bugzilla why the reporter is abusing urandom in
>> this way.  The other commenter on the bug replicated the problem, but
>> that's not a "second bug report" in my book.
>> 
>> At the very least, this will probably cause me to insert a warning
>> printk: "insane user of /dev/urandom: [current->comm] requested %d
>> bytes" whenever someone tries to request more than 4k.
> 
> Ok, I would be fine with that.
> 
> The dd if=/dev/urandom of=random_file.dat seems reasonable to me to try
> to not break it. But, of course, there are other possibilities.

Personally, I'd say that _is_ insane - reading from urandom still consumes 
entropy (causing readers of /dev/random to block more often); when 
alternatives (such as dd'ing to dm-crypt) both avoid the issue _and_ are 
faster then it should very well be considered pathological.

