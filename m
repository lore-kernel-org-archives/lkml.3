Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834AbaJ3EAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:00:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54721 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaJ3EAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:00:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no, Andy Lutomirski <luto@amacapital.net>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
Date: Wed, 29 Oct 2014 20:59:44 -0700
In-Reply-To: <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
	(Greg Kroah-Hartman's message of "Wed, 29 Oct 2014 15:00:52 -0700")
Message-ID: <8738a6w6kv.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ckXUiUDK/23EBvHngH9oE1st5dchScOE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4768]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 351 ms - load_scoreonly_sql: 0.08 (0.0%),
	signal_user_changed: 4.3 (1.2%), b_tie_ro: 3.1 (0.9%), parse: 1.59 (0.5%),
	extract_message_metadata: 20 (5.6%), get_uri_detail_list: 3.0 (0.9%),
	tests_pri_-1000: 9 (2.5%), tests_pri_-950: 1.43 (0.4%), tests_pri_-900: 1.32
	(0.4%), tests_pri_-400: 27 (7.6%), check_bayes: 25 (7.2%), b_tokenize: 7
	(2.0%), b_tok_get_all: 10 (3.0%), b_comp_prob: 2.7 (0.8%), b_tok_touch_all:
	2.6 (0.7%), b_finish: 0.73 (0.2%), tests_pri_0: 277 (78.9%), tests_pri_500: 6
	(1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: kdbus: add code for buses, domains and endpoints
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

The way capabilities are checked in this patch make me very nervous.

We are not checking permissions at open time.  Every other location
of calling capable on file like objects has been show to be suceptible
to file descriptor pass attacks.

> See Documentation/kdbus.txt for more details.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

> diff --git a/drivers/misc/kdbus/bus.c b/drivers/misc/kdbus/bus.c
> new file mode 100644
> index 000000000000..6dcaf22f5d59
> --- /dev/null
> +++ b/drivers/misc/kdbus/bus.c
> @@ -0,0 +1,450 @@

> +/**
> + * kdbus_bus_cred_is_privileged() - check whether the given credentials in
> + *				    combination with the capabilities of the
> + *				    current thead are privileged on the bus
> + * @bus:		The bus to check
> + * @cred:		The credentials to match
> + *
> + * Return: true if the credentials are privileged, otherwise false.
> + */
> +bool kdbus_bus_cred_is_privileged(const struct kdbus_bus *bus,
> +				  const struct cred *cred)
> +{
> +	/* Capabilities are *ALWAYS* tested against the current thread, they're
> +	 * never remembered from conn-credentials. */
> +	if (ns_capable(&init_user_ns, CAP_IPC_OWNER))
> +		return true;
> +
> +	return uid_eq(bus->uid_owner, cred->fsuid);
> +}
> +
> +/**
> + * kdbus_bus_uid_is_privileged() - check whether the current user is a
> + *				   priviledged bus user
> + * @bus:		The bus to check
> + *
> + * Return: true if the current user has CAP_IPC_OWNER capabilities, or
> + * if it has the same UID as the user that created the bus. Otherwise,
> + * false is returned.
> + */
> +bool kdbus_bus_uid_is_privileged(const struct kdbus_bus *bus)
> +{
> +	return kdbus_bus_cred_is_privileged(bus, current_cred());
> +}


> +/**
> + * kdbus_bus_new() - create a new bus
> + * @domain:		The domain to work on
> + * @make:		Pointer to a struct kdbus_cmd_make containing the
> + *			details for the bus creation
> + * @name:		Name of the bus
> + * @bloom:		Bloom parameters for this bus
> + * @mode:		The access mode for the device node
> + * @uid:		The uid of the device node
> + * @gid:		The gid of the device node
> + * @bus:		Pointer to a reference where the new bus is stored
> + *
> + * This function will allocate a new kdbus_bus and link it to the given
> + * domain.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int kdbus_bus_new(struct kdbus_domain *domain,
> +		  const struct kdbus_cmd_make *make,
> +		  const char *name,
> +		  const struct kdbus_bloom_parameter *bloom,
> +		  umode_t mode, kuid_t uid, kgid_t gid,
> +		  struct kdbus_bus **bus)
> +{
[snip]
> +
> +	if (!capable(CAP_IPC_OWNER) &&
> +	    atomic_inc_return(&b->user->buses) > KDBUS_USER_MAX_BUSES) {
> +		atomic_dec(&b->user->buses);
> +		ret = -EMFILE;
> +		goto exit_unref_user_unlock;
> +	}
> +
