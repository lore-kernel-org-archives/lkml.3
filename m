Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab3LMF1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:27:36 -0500
Received: from imap.thunk.org ([74.207.234.97]:39608 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab3LMF1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:27:35 -0500
Date: Fri, 13 Dec 2013 00:27:12 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213052712.GH23888@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kees Cook <keescook@chromium.org>, vegard.nossum@oracle.com,
	LKML <linux-kernel@vger.kernel.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	James Morris <james.l.morris@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
> > Suppose we put put this into the mainstream kernel.  Wouldn't writers
> > of root kit adapt by checking for the kernel version to avoid checking
> > for exploits that are known not work?  So the question is whether the
> > additional complexity in the kernel is going to be worth it, since
> > once the attackers adapt, the benefits of trying to detect attacks for
> > mitigated exploits will be minimal.
> 
> This is already somewhat the case, but I think this idea still has
> value. The reality of the situation is that the kernels running on an
> end-user's system is rarely a stock upstream kernel. As a result, they
> usually have organization-specific versioning, which makes
> version-only autodetection useless to an attacker.

Most organizations can't afford to have an in-house kernel team
providing specialized kernels for their server farms or their
customized desktop distributions.  :-)

Some places have publically said that they do this; Google has
publically talked about Goobuntu and their data center production
kernels, and some financial firms on Wall Street have boasted about
how they run with a customized kernel --- although other financial
firms have said they don't want to do that because they don't want to
void their support contract with Red Hat or SuSE.  I suspect that at
most shopes, though, the latter is going to be far more common than
the former.

Practically speaking, testing for various distribution kernel
versions, as well as specific ChromeOS and Android kernel versions,
wouldn't be that difficult for an attacker, and would probably allow
them to avoid detection for 99% of the Linux systems found in the
wild.  It would certainly be useful for detecting attempted attacks
for private kernels where the configuration and security patches
applied for some internal kernel are not public --- and if that caused
the botnet author to be paranoid enough to avoid attacking machines
which didn't have a known distribution kernel that definitely had that
vulnerability, it would certainly be good for people running their own
privately maintained kernel image.  So if this increases the market
demand for kernel programmers, that's a good thing, right?   :-)

I am at least partially sympathetic to the concerns which Greg has
raised, though.  At the very least the exploit() tags should also have
a date stamp, so it we can automatically scan for exploit tags whose
time has come and gone.

I'm also worried about false positives getting triggered due to
userspace bugs, corrupted file systems, or other random hardare
failures.  This could be a support headache for distributions, and
possibly for other kernel support organizations as well.  Given that
attack authors will probably adapt their explots to only try them on
known RHEL/SLES kernels that have the bug, it wouldn't surprise me if
enterprise distro's such as Red Hat and SuSE will very likely simply
not turn on the config option.

This could probably be mitigated by adding more sophisticated
hueristics, but then we could potentially end up changing a one-line
exploit() or exploit_on() call to something substantially more
bloated, and at that point we will seriously be uglifying the code and
making it harder to read and maintain.  So despite the risks of false
positives, I suspect we will want to keep the inserted exploit() calls
as simple and as lightweight as possible.

          	       	     	    	 - Ted
