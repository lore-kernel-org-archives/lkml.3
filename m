Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3CLSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:48:45 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:12224 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3CLSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:48:44 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r7QwWecjzg=
X-RZG-CLASS-ID: mo00
Date: Tue, 12 Mar 2013 19:48:39 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Message-ID: <20130312184839.GA30976@aepfle.de>
References: <1363114406-30575-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363114406-30575-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, K. Y. Srinivasan wrote:

> +static int vss_operate(int operation)
> +{
> +	char *fs_op;
> +	char cmd[512];
> +	char buf[512];
> +	FILE *file;
> +	char *p;
> +	char *x;
> +	int error;
> +
> +	switch (operation) {
> +	case VSS_OP_FREEZE:
> +		fs_op = "-f ";
> +		break;
> +	case VSS_OP_THAW:
> +		fs_op = "-u ";
> +		break;
> +	}
> +
> +	sprintf(cmd, "%s", "mount | grep ^/dev/ | awk '{print $3 }'");

I think this can be char cmd[] = "mount | awk '/^\/dev\/ { print $3'";

> +	file = popen(cmd, "r");
> +	if (file == NULL)
> +		return;
> +
> +	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
> +		x = strchr(p, '\n');
> +		*x = '\0';
> +		if (!strncmp(p, "/", sizeof("/")))
> +			continue;
> +
> +		sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, p);
> +		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> +		error = system(cmd);

error is not handled here, and it looks like only one error can be
reported anyway.
In case of an error, will the host thaw the filesystems?

> +	}
> +	pclose(file);
> +
> +	sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, "/");
> +	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> +	error = system(cmd);
> +
> +	return error;
> +}

