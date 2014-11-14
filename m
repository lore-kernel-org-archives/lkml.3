Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161723AbaKNRr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:47:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:60230 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161182AbaKNRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:47:58 -0500
Date: Fri, 14 Nov 2014 12:47:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 14/23 v4] tracing: Convert seq_buf_path() to be
 like seq_path()
Message-ID: <20141114124747.4a1ca768@gandalf.local.home>
In-Reply-To: <20141114165308.GB14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
	<20141114011412.338523371@goodmis.org>
	<20141114165308.GB14538@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 17:53:08 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> >  /**
> > diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> > index 3c63b619d6b7..475412e31de5 100644
> > --- a/kernel/trace/trace_seq.c
> > +++ b/kernel/trace/trace_seq.c
> > @@ -342,7 +342,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
> >  		return 0;
> >  	}
> >  
> > -	ret = seq_buf_path(&s->seq, path);
> > +	ret = seq_buf_path(&s->seq, path, "\n");
> >  
> >  	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> >  		s->seq.len = save_len;
> > @@ -350,7 +350,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
> >  		return 0;
> >  	}
> >  
> > -	return ret;
> > +	return 1;
> 
> Ah, I have just realized that this should return -1 when
> seq_buf_path() returns -1.

It really doesn't matter as long as it's not zero. The one user just
tests if the return is zero or not.

trace_seq() doesn't have to follow all the same rules as seq_buf()
does, as seq_buf() is more in line with seq_file().


> 
> Note that set_buf_path() does not longer calls seq_buf_set_overflow(s)
> when the path handling fails. Therefore the above check for overflow
> will probably never happen.

This is in a transitional state of the patch series. The final version
of seq_buf_path() will call seq_buf_commit() which will put the seq_buf
in an overflow state if it isn't correct. Trying to fix this version
here will probably just cause me to make another stupid mistake and
ruin the final version ;-)

-- Steve

> 
> Best Regards,
> Petr
> 
> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_path);
> >  
> > -- 
> > 2.1.1
> > 
> > 

