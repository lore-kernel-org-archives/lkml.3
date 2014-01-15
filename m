Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaAOSmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:42:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbaAOSms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:42:48 -0500
Date: Wed, 15 Jan 2014 19:42:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] tools lib traceevent: fix pointer-integer size
 mismatch
Message-ID: <20140115184230.GF17358@krava.redhat.com>
References: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
 <1389782648-4417-3-git-send-email-mark.rutland@arm.com>
 <20140115181406.GB9750@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140115181406.GB9750@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 03:14:06PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 15, 2014 at 10:44:07AM +0000, Mark Rutland escreveu:
> > The scsi and cfg80211 plugins cast between unsigned long long and
> > pointers, which is problematic for architectures where unsigned long
> > long is wider than the native pointer size:
> > 
> >   linux/tools/lib/traceevent/plugin_scsi.c: In function ‘process_scsi_trace_parse_cdb’:
> >   linux/tools/lib/traceevent/plugin_scsi.c:408:26: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >     scsi_trace_parse_cdb(s, (unsigned char *) args[1], args[2]);
> > 
> >   linux/tools/lib/traceevent/plugin_cfg80211.c: In function ‘process___le16_to_cpup’:
> >   linux/tools/lib/traceevent/plugin_cfg80211.c:11:18: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >     uint16_t *val = (uint16_t *) args[0];
> > 
> > This patch adds an intermediate cast to unsigned long, silencing the
> > warning.
> 
> Steven, Jiri: Acked-by?
>  

yep, looks ok.. args values hold pointer values, so it's ok to
convert them to pointer's size, 'unsigned long' has pointer's
size on x86-32/64.

also it compiles for me ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > ---
> >  tools/lib/traceevent/plugin_cfg80211.c | 2 +-
> >  tools/lib/traceevent/plugin_scsi.c     | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > I'm not sure about this one as I'm not certain I read all the sites
> > input values for args could be generated. I'd appreciate if someone more
> > familiar with traceevent plugins could verify this makes sense.
> > 
> > Mark.
> > 
> > diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
> > index dcab8e8..57e9822 100644
> > --- a/tools/lib/traceevent/plugin_cfg80211.c
> > +++ b/tools/lib/traceevent/plugin_cfg80211.c
> > @@ -8,7 +8,7 @@ static unsigned long long
> >  process___le16_to_cpup(struct trace_seq *s,
> >  		       unsigned long long *args)
> >  {
> > -	uint16_t *val = (uint16_t *) args[0];
> > +	uint16_t *val = (uint16_t *) (unsigned long) args[0];
> >  	return val ? (long long) le16toh(*val) : 0;
> >  }
> >  
> > diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
> > index 6fb8e3e..7ef16cc 100644
> > --- a/tools/lib/traceevent/plugin_scsi.c
> > +++ b/tools/lib/traceevent/plugin_scsi.c
> > @@ -405,7 +405,7 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
> >  unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
> >  						unsigned long long *args)
> >  {
> > -	scsi_trace_parse_cdb(s, (unsigned char *) args[1], args[2]);
> > +	scsi_trace_parse_cdb(s, (unsigned char *) (unsigned long) args[1], args[2]);
> >  	return 0;
> >  }
> >  
> > -- 
> > 1.8.1.1
