Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaHSMay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:30:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60129 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbaHSMaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:30:52 -0400
X-Sasl-enc: fGDenvw9NV4OsM9eqWxcqvaNlXewvaVwFSFlUdczNlmJ 1408451450
Message-ID: <1408451448.11314.11.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2014 20:30:48 +0800
In-Reply-To: <20140819211654.5ec3853a@notabene.brown>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	 <1408350340.2533.3.camel@perseus.fritz.box>
	 <1408442547.11314.9.camel@perseus.themaw.net>
	 <20140819211654.5ec3853a@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 21:16 +1000, NeilBrown wrote:
> On Tue, 19 Aug 2014 18:02:27 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On Mon, 2014-08-18 at 16:25 +0800, Ian Kent wrote:
> > > On Mon, 2014-08-18 at 16:33 +1000, NeilBrown wrote:
> > > > Hi Ian,
> > > >  Have you had a chance to run your tests in these patches yet?
> > > >  I've done what testing I can think of and cannot fault them.
> > > 
> > > I haven't, I've been plagued with illness so I'm not getting nearly
> > > enough done. I'll try to put a kernel together and run the test in the
> > > next week or so.
> > 
> > Just to let you know that I managed to spend some time on this. I built
> > a kernel (3.17.0-rc1) with the series and ran a couple of tests.
> > 
> > I'm not certain that the patches I used are identical to your posting, I
> > saw one difference, after the fact, that shouldn't matter, I'll have to
> > check that.
> > 
> > It isn't possible to test expire to mount races because the mounts in
> > the tree never expire.
> > 
> > At first I thought it was because so many processes were accessing the
> > tree all the time but manually constructing the maps and mounting the
> > mounts shows that nothing ever expires, at least for this tree.
> > 
> > However, issuing a shut down does expire all the mounts and shuts down
> > autofs cleanly.
> > 
> > So there is something not quite right with the expire check or my
> > patches have mistakes.
> 
> Ahh.. I bet I know what it is.
> autofs4_can_expire() isn't idempotent.
> Because we call should_expire twice, autofs4_can_expire() is called twice and
> the second time it failed because  the first time it resets ->last_used.

LOL, indeed that looks like it.
I'll carefully check the patches anyway, rebuild and re-test.

> 
> diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> index eb4b770a4bf6..80133a9d9427 100644
> --- a/fs/autofs4/expire.c
> +++ b/fs/autofs4/expire.c
> @@ -26,6 +26,9 @@ static inline int autofs4_can_expire(struct dentry *dentry,
>  	if (ino == NULL)
>  		return 0;
>  
> +	if (ino->flags & AUTOFS_INF_NO_RCU)
> +		/* Already performed this test */
> +		return 1;
>  	if (!do_now) {
>  		/* Too young to die */
>  		if (!timeout || time_after(ino->last_used + timeout, now))
> 
> 
> 
> might fix it, but might be a hack.
> (tests.... yep, that seems to fix it).
> 
> I'll think some more tomorrow.
> 
> Thanks,
> NeilBrown


