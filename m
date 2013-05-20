Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3ETKVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:21:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:12222 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3ETKVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:21:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="340441431"
Date: Mon, 20 May 2013 13:25:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: implement acpi_os_get_timer() according the spec
Message-ID: <20130520102530.GG11878@intel.com>
References: <1368440871-27552-1-git-send-email-mika.westerberg@linux.intel.com>
 <9521576.ePuIMg9qsX@vostro.rjw.lan>
 <20130513114432.GK20562@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513114432.GK20562@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 02:44:32PM +0300, Mika Westerberg wrote:
> On Mon, May 13, 2013 at 01:38:46PM +0200, Rafael J. Wysocki wrote:
> > On Monday, May 13, 2013 01:27:51 PM Mika Westerberg wrote:
> > > ACPI Timer() opcode should return monotonically increasing clock with 100ns
> > > granularity. Implement this with the help of ktime_get().
> > > 
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > That looks reasobable.  Have you tested it?
> 
> Very lightly. Basically I added some debug printks() between two
> successsive calls of Timer() and it seemed like it returned correct time.
> 
> It is certainly better than returning t+1 every time Timer() is called :)

I did somewhat better test for this. I added following ASL code:

	...
	Store(Timer, Local1)
	Sleep(10)
	Divide(Subtract(Timer, Local1), 10000,, Local1)
	Sleep(Local1)

	Store(Timer, Local1)
	Sleep(200)
	Divide(Subtract(Timer, Local1), 10000,, Local1)
	Sleep(Local1)

	Store(Timer, Local1)
	Sleep(1300)
	Divide(Subtract(Timer, Local1), 10000,, Local1)
	Sleep(Local1)

The second sleep should be pretty close to the first one.

Without this patch I get:

[   11.488100] ACPI: acpi_os_get_timer() TBD
[   11.492150] ACPI: Sleep(10)
[   11.502993] ACPI: Sleep(0)
[   11.506315] ACPI: Sleep(200)
[   11.706237] ACPI: Sleep(0)
[   11.709550] ACPI: Sleep(1300)
[   13.008929] ACPI: Sleep(0)

With the patch applied I get:

[   11.486786] ACPI: Sleep(10)
[   11.499029] ACPI: Sleep(12)
[   11.512350] ACPI: Sleep(200)
[   11.712282] ACPI: Sleep(200)
[   11.912170] ACPI: Sleep(1300)
[   13.211577] ACPI: Sleep(1300)

The above looks much more correct to me.
