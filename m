Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab3IIIbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:31:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IIIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:31:00 -0400
Date: Mon, 9 Sep 2013 10:30:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130909083028.GH31370@twins.programming.kicks-ass.net>
References: <5220FD51.2010709@hp.com>
 <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
 <20130830205404.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
 <20130830214452.GH13318@ZenIV.linux.org.uk>
 <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
 <20130831212355.GN13318@ZenIV.linux.org.uk>
 <CA+55aFwxQ2zN+kbt0Atob-Rims4B1pxgFniXbbA=YDAfb+wWAg@mail.gmail.com>
 <20130831232758.GO13318@ZenIV.linux.org.uk>
 <20130901001306.GP13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130901001306.GP13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 01:13:06AM +0100, Al Viro wrote:

> +static noinline_for_stack
> +char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_spec spec,
> +		  int depth)
> +{
> +	int i, n = 0;
> +	const char *s;
> +	char *p = buf;
> +	const struct dentry *array[4];
> +	char c;
> +
> +	if (depth < 0) {
> +		depth = 1;
> +		WARN_ON(1);
> +	}
> +	if (depth > 4) {
> +		depth = 4;
> +		WARN_ON(1);
> +	}
> +
> +	rcu_read_lock();
> +	for (i = 0; i < depth; i++) {
> +		struct dentry *p = ACCESS_ONCE(d->d_parent);
> +		array[i] = d;
> +		if (d == p)
> +			break;
> +		d = p;
> +	}
> +	if (!i) {	/* root dentry has a bloody inconvenient name */
> +		i++;
> +		goto do_name;
> +	}
> +	if (i == depth)
> +		goto do_name;
> +	while (i && n != spec.precision) {
> +		if (buf < end)
> +			*buf = '/';
> +		buf++;
> +		n++;
> +do_name:
> +		s = ACCESS_ONCE(array[--i]->d_name.name);
> +		while (n != spec.precision && (c = *s++) != '\0') {
> +			if (buf < end)
> +				*buf = c;
> +			buf++;
> +			n++;
> +		}
> +	}
> +	rcu_read_unlock();

Should one or both of those ACCESS_ONCE()s be an rcu_dereference()?
