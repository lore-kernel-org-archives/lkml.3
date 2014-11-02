Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaKBLNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 06:13:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57019 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKBLNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 06:13:41 -0500
Date: Sun, 2 Nov 2014 12:13:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <trivial@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, cpu: trivial printk formatting fixes
Message-ID: <20141102111336.GD5229@pd.tnic>
References: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
 <20141101171909.GA5034@pd.tnic>
 <CABz95_BFew81JGAf=oP=6m9yPMi1_JmvfjKgX2CxFmha52A54w@mail.gmail.com>
 <20141101175129.GC4462@pd.tnic>
 <CABz95_CYGw1sBro2GtehyczYCEBs-SrSzkgF64ibJsdDvQ24VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABz95_CYGw1sBro2GtehyczYCEBs-SrSzkgF64ibJsdDvQ24VA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 04:03:52AM +0000, Steven Honeyman wrote:
> Hmm - the difference is to do with the source of the kernel ring
> buffer. The old output format be obtained using the latest dmesg by
> adding "-S", which uses syslog(2) rather than /dev/kmsg.
> (added in commit 7af230601ab)
> 
> The klogctl version interprets the \n and adds the timestamp
> afterwards, but /dev/kmsg changes the '\n' to "\x0a" resulting in:
> 4,355,10557,-;ENERGY_PERF_BIAS: Set to 'normal', was
> 'performance'\x0aENERGY_P...
> 
> It looks as though it's just a matter of opinion/preference whether
> control characters are printed (rfc5424)

Right, I see what you mean. There's this in the /dev/kmsg code

---
 * /dev/kmsg exports the structured data in the following line format:
 *   "level,sequnum,timestamp;<message text>\n"
 *
 * The optional key/value pairs are attached as continuation lines starting
 * with a space character and terminated by a newline. All possible
 * non-prinatable characters are escaped in the "\xff" notation.
 *
 * Users of the export format should ignore possible additional values
 * separated by ',', and find the message after the ';' character.
 */
--

and also

---
        /* escape non-printable characters */
        for (i = 0; i < msg->text_len; i++) {
                unsigned char c = log_text(msg)[i];

                if (c < ' ' || c >= 127 || c == '\\')
                        len += sprintf(user->buf + len, "\\x%02x", c);
                else
                        user->buf[len++] = c;
        }
--

in devkmsg_read().

Hmm, so this all looks like an agreed upon thing or whatever. Oh, and
btw, if you don't enable printk timestamping, you won't see the issue.

I'd say the simplest solution - and this is only me and I like practical
- is to accept your patch after all and stop wasting time with this :-)

Only after you fix it, though, to *not* change log levels for the other
printk message. FWIW, your change even improves the readability a bit of
those printks.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
