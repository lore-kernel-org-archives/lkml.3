Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaFVNSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 09:18:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51512 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751659AbaFVNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 09:18:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kevin Hilman <khilman@linaro.org>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Sun, 22 Jun 2014 15:35:54 +0200
Message-ID: <2724221.P8uryjLFJe@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406210913470.26962-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1406210913470.26962-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 21, 2014 09:34:28 AM Alan Stern wrote:
> On Fri, 20 Jun 2014, Kevin Hilman wrote:
> 
> > > For a general device, the fact that dev->power.is_suspended is set
> > > means the device _has_ been powered down.  Even though the
> > > runtime_status may not have changed, the PM core has to assume the
> > > device is not available for use.
> > 
> > This is where things get fuzzy because of the overlap between system PM
> > and runtime PM.  It makes sense that from a system PM perspecitve, the
> > core has to assume the device isn't available.  But from a runtime PM
> > perspective, we know that it is, so we allow the *runtime PM* requests
> > to succeed.
> 
> Well, to be fair, from a runtime PM perspective the core _doesn't_
> know that the device is available.  For example, if we were talking
> about a USB device rather than an I2C device, it _wouldn't_ be
> available.
> 
> The fact is, after ->suspend returns some devices are still available
> and some aren't.  Currently the PM core doesn't know which are which.

That's correct.  As a result of this, the core should not make any assumptions
about the device's physical state after ->suspend() has been executed.

Well, the core shouldn't actually make any assumptions about the device's
physical state at any given time at all, because it never knows what that state
is.

What it can do (and what the runtime PM rules are for) is to refuse to carry
out operations that generally don't make sense, like calling ->runtime_resume()
twice in a row, for example.

Currently, we have separate rules for runtime PM and for system suspend/resume,
but it looks like we really need to establish a set of rules that will cover
*both* runtime PM and system suspend/resume at the same time.  Of course, it
needs to be compatible with the existing rules as far as reasonably possible.

Rafael

