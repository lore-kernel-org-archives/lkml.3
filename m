Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3B1BcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:32:02 -0500
Received: from fn.samba.org ([216.83.154.106]:42741 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab3B1BcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:32:00 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 20:32:00 EST
Message-ID: <1362014704.2057.1.camel@pico.ipa.ssimo.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
From: simo <idra@samba.org>
To: Dave Chiluk <dave.chiluk@canonical.com>
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Dave Chiluk <chiluk@canonical.com>
Date: Wed, 27 Feb 2013 20:25:04 -0500
In-Reply-To: <512E8C31.8070106@canonical.com>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	 <512DE8A6.9030000@samba.org>
	 <20130227083419.0af9deaf@corrin.poochiereds.net>
	 <512E8787.6070709@canonical.com>
	 <CAH2r5mvM=OX+F4uqMh_c24DXLxwgRX2UzX3bsYqM00JPzbtjqA@mail.gmail.com>
	 <512E8C31.8070106@canonical.com>
Organization: Samba Team
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 16:44 -0600, Dave Chiluk wrote:
> On 02/27/2013 04:40 PM, Steve French wrote:
> > On Wed, Feb 27, 2013 at 4:24 PM, Dave Chiluk <dave.chiluk@canonical.com> wrote:
> >> On 02/27/2013 10:34 AM, Jeff Layton wrote:
> >>> On Wed, 27 Feb 2013 12:06:14 +0100
> >>> "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
> >>>
> >>>> Hi Dave,
> >>>>
> >>>>> When messages are currently in queue awaiting a response, decrease amount of
> >>>>> time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
> >>>>> wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
> >>>>> seconds) since the last response was recieved.  This does not take into account
> >>>>> the fact that messages waiting for a response should be serviced within a
> >>>>> reasonable round trip time.
> >>>>
> >>>> Wouldn't that mean that the client will disconnect a good connection,
> >>>> if the server doesn't response within 10 seconds?
> >>>> Reads and Writes can take longer than 10 seconds...
> >>>>
> >>>
> >>> Where does this magic value of 10s come from? Note that a slow server
> >>> can take *minutes* to respond to writes that are long past the EOF.
> >> It comes from the desire to decrease the reconnection delay to something
> >> better than a random number between 60 and 120 seconds.  I am not
> >> committed to this number, and it is open for discussion.  Additionally
> >> if you look closely at the logic it's not 10 seconds per request, but
> >> actually when requests have been in flight for more than 10 seconds make
> >> sure we've heard from the server in the last 10 seconds.
> >>
> >> Can you explain more fully your use case of writes that are long past
> >> the EOF?  Perhaps with a test-case or script that I can test?  As far as
> >> I know writes long past EOF will just result in a sparse file, and
> >> return in a reasonable round trip time *(that's at least what I'm seeing
> >> with my testing).  dd if=/dev/zero of=/mnt/cifs/a bs=1M count=100
> >> seek=100000, starts receiving responses from the server in about .05
> >> seconds with subsequent responses following at roughly .002-.01 second
> >> intervals.  This is well within my 10 second value.
> > 
> > Note that not all Linux file systems support sparse files and
> > certainly there are cifs servers running on operating systems other
> > than Linux which have popular file systems which don't support sparse
> > files (e.g. FAT32 but there are many others) - in any case, writes
> > after end of file can take a LONG time if sparse files are not
> > supported and I don't know a good way for the client to know that
> > attribute of the server file system ahead of time (although we could
> > attempt to set the sparse flag, servers can and do lie)
> > 
> 
> It doesn't matter how long it takes for the entire operation to
> complete, just so long as the server acks something in less than 10
> seconds.  Now the question becomes, is there an OS out there that
> doesn't ack the request or doesn't ack the progress regularly.

IIRC older samba servers were fully synchronous and wouldn't reply to
anything while processing an operation. I am sure you can still find old
code bases in older (and slow) appliances out there.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Principal Software Engineer at Red Hat, Inc. <simo@redhat.com>

