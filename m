Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3CaXlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:41:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3CaXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:41:35 -0400
Date: Mon, 1 Apr 2013 01:41:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Andreas Dilger <adilger@dilger.ca>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: openat(..., AT_UNLINKED) was Re: New copyfile system call -
 discuss before LSF?
Message-ID: <20130331234133.GB32174@amd.pavel.ucw.cz>
References: <20130330214509.GB4322@amd.pavel.ucw.cz>
 <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
 <20130331073604.GA13159@amd.pavel.ucw.cz>
 <1364754452.4771.10.camel@leira.trondhjem.org>
 <20130331183238.GA25751@amd.pavel.ucw.cz>
 <1364755493.4771.14.camel@leira.trondhjem.org>
 <20130331225022.GA31552@amd.pavel.ucw.cz>
 <5158C347.3090400@redhat.com>
 <20130331231854.GA32174@amd.pavel.ucw.cz>
 <5158C6A8.9020505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5158C6A8.9020505@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>User wants to test for a file with name "foo.txt"
> >>
> >>* create "foo.txt~" (or whatever)
> >>* write contents into "foo.txt~"
> >>* rename "foo.txt~" to "foo.txt"
> >>
> >>Until rename is done, the file does not exists and is not complete.
> >>You will potentially have a garbage file to clean up if the program
> >>(or system) crashes, but that is not racy in a classic sense, right?
> >Well. If people rsync from you, they will start fetching incomplete
> >foo.txt~. Plus the garbage issue.
> 
> That is not racy, just garbage (not trying to be pedantic, just
> trying to understand). I can see that the "~" file is annoying, but
> we have dealt with it for a *long* time :)

Ok, so lets keep it at "~" is annoying :-).

[But... I was wrong. openat(..., AT_UNLINKED) is not enough to solve
this: we do not have flink() and it is not easily possible to link
deleted file "back to life" from /proc/self/fd:

pavel@amd:/tmp$ > delme
pavel@amd:/tmp$ bash 3< delme &
[2] 32667
[2]+  Stopped                 bash 3< delme
pavel@amd:/tmp$ fg
bash 3< delme
pavel@amd:/tmp$ ls -al delme
-rw-r--r-- 1 pavel pavel 0 Apr  1 01:36 delme
pavel@amd:/tmp$ ls -al /proc/self/fd/3 
lr-x------ 1 pavel pavel 64 Apr  1 01:37 /proc/self/fd/3 -> /tmp/delme
pavel@amd:/tmp$ rm delme
pavel@amd:/tmp$ ls -al /proc/self/fd/3 
lr-x------ 1 pavel pavel 64 Apr  1 01:37 /proc/self/fd/3 -> /tmp/delme
(deleted)
pavel@amd:/tmp$ ln /proc/self/fd/3 delme2
ln: creating hard link `delme2' => `/proc/self/fd/3': Invalid
cross-device link
]

> >>This is more of a garbage clean up issue?
> >Also. Plus sometimes you want temporary "file" that is
> >deleted. Terminals use it for history, etc...
> 
> There you would have a race, you can create a file and unlink it of
> course and still write to it, but you would have a potential empty
> file issue?

Yes. openat(..., AT_UNLINKED) solves that -- you'll no longer get
those files. (Not sure they'd be always empty. How do you ensure rm
hits the disk? fsync() on parent directory? Sounds expensive.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
